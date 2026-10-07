import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../domain/entities/inventory_views.dart';
import '../domain/services/restock_threshold_evaluator.dart';

/// Reads and writes kitchen inventory (per-batch), and keeps the restock list
/// in sync via [RestockThresholdEvaluator] whenever stock changes.
class InventoryRepository {
  InventoryRepository(this._db, {RestockThresholdEvaluator? evaluator})
    : _evaluator = evaluator ?? const RestockThresholdEvaluator();

  final AppDatabase _db;
  final RestockThresholdEvaluator _evaluator;

  /// Loads a single inventory batch by id (for the edit screen).
  Future<InventoryItem?> getBatch(String id) {
    return (_db.select(_db.inventoryItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Canonical ingredients, for the add/edit autocomplete.
  Future<List<Ingredient>> getAllIngredients() {
    return (_db.select(_db.ingredients)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  /// Watches inventory rolled up per ingredient for one kitchen (reactive).
  Stream<List<IngredientStockView>> watchStockViews(String kitchenId) {
    final query = _db.select(_db.inventoryItems).join([
      leftOuterJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.inventoryItems.ingredientId),
      ),
    ])..where(_db.inventoryItems.kitchenId.equals(kitchenId));

    return query.watch().map((rows) {
      final views = rows.map((r) => InventoryBatchView(
            batch: r.readTable(_db.inventoryItems),
            ingredient: r.readTableOrNull(_db.ingredients),
          ));
      return _rollUp(views.toList());
    });
  }

  List<IngredientStockView> _rollUp(List<InventoryBatchView> batches) {
    final byKey = <String, List<InventoryBatchView>>{};
    for (final b in batches) {
      final key = b.batch.ingredientId ?? 'custom:${b.displayName}';
      byKey.putIfAbsent(key, () => []).add(b);
    }

    final result = <IngredientStockView>[];
    byKey.forEach((key, group) {
      group.sort((a, b) => a.batch.expiryDate.compareTo(b.batch.expiryDate));
      final total = group.fold<double>(0, (s, b) => s + b.batch.quantity);
      result.add(IngredientStockView(
        ingredientId: group.first.batch.ingredientId ?? key,
        displayName: group.first.displayName,
        totalQuantity: total,
        unit: group.first.batch.unit.name,
        batches: group,
        soonestExpiry: group.first.batch.expiryDate,
      ));
    });

    result.sort((a, b) {
      final ae = a.soonestExpiry, be = b.soonestExpiry;
      if (ae == null && be == null) return a.displayName.compareTo(b.displayName);
      if (ae == null) return 1;
      if (be == null) return -1;
      return ae.compareTo(be);
    });
    return result;
  }

  /// Inserts or updates a batch, then re-evaluates restock for its ingredient
  /// within that batch's kitchen.
  Future<void> upsertBatch(InventoryItemsCompanion batch) async {
    await _db.into(_db.inventoryItems).insertOnConflictUpdate(batch);
    final ingredientId = batch.ingredientId.value;
    final kitchenId = batch.kitchenId.present
        ? batch.kitchenId.value
        : AppDatabase.homeKitchenId;
    if (ingredientId != null) await _syncRestock(ingredientId, kitchenId);
  }

  /// Deletes a batch and re-evaluates restock for its kitchen.
  Future<void> deleteBatch(String id) async {
    final row = await (_db.select(_db.inventoryItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.inventoryItems)..where((t) => t.id.equals(id))).go();
    final ingredientId = row?.ingredientId;
    if (ingredientId != null) await _syncRestock(ingredientId, row!.kitchenId);
  }

  /// Recomputes restock state for every stock-policy ingredient in a kitchen.
  /// Called on app resume so missed changes are reconciled.
  Future<void> recomputeAllRestock(String kitchenId) async {
    final policies = await _db.select(_db.ingredientStockPolicies).get();
    for (final p in policies) {
      await _syncRestock(p.ingredientId, kitchenId);
    }
  }

  /// Core restock reconciliation for one ingredient in one kitchen (A1).
  Future<void> _syncRestock(String ingredientId, String kitchenId) async {
    final policy = await (_db.select(_db.ingredientStockPolicies)
          ..where((t) => t.ingredientId.equals(ingredientId)))
        .getSingleOrNull();
    if (policy == null) return; // only staples with a policy are auto-tracked

    final now = DateTime.now();
    final batches = await (_db.select(_db.inventoryItems)
          ..where((t) =>
              t.ingredientId.equals(ingredientId) &
              t.kitchenId.equals(kitchenId)))
        .get();
    // Sum only non-expired stock.
    final onHand = batches
        .where((b) => !b.expiryDate.isBefore(DateTime(now.year, now.month, now.day)))
        .fold<double>(0, (s, b) => s + b.quantity);

    final existing = await (_db.select(_db.restockListItems)
          ..where((t) =>
              t.ingredientId.equals(ingredientId) &
              t.kitchenId.equals(kitchenId) &
              t.isResolved.equals(false)))
        .getSingleOrNull();

    final decision = _evaluator.evaluate(
      onHand: onHand,
      parQuantity: policy.parQuantity,
      thresholdPercent: policy.thresholdPercent,
      currentlyListed: existing != null,
    );

    if (decision.shouldBeListed && existing == null) {
      final ingredient = await (_db.select(_db.ingredients)
            ..where((t) => t.id.equals(ingredientId)))
          .getSingleOrNull();
      final suggested = policy.parQuantity - onHand;
      await _db.into(_db.restockListItems).insert(
            RestockListItemsCompanion.insert(
              id: 'auto_${kitchenId}_$ingredientId',
              kitchenId: Value(kitchenId),
              ingredientId: Value(ingredientId),
              itemName: ingredient?.name ?? ingredientId,
              suggestedQuantity: Value(suggested > 0 ? suggested : null),
              unit: Value(policy.unit),
              reason: RestockReason.lowStock,
              addedAt: now,
            ),
            mode: InsertMode.insertOrReplace,
          );
    } else if (!decision.shouldBeListed && existing != null) {
      // Only auto-resolve items that were auto-added (leave manual entries).
      if (existing.reason == RestockReason.lowStock) {
        await (_db.update(_db.restockListItems)
              ..where((t) => t.id.equals(existing.id)))
            .write(const RestockListItemsCompanion(isResolved: Value(true)));
      }
    }
  }
}
