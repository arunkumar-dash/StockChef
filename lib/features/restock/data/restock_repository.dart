import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';

/// Reads and mutates the restock list. Auto-generated low-stock rows are
/// written by [InventoryRepository]; this repository handles reads plus manual
/// add / edit / resolve / delete from the restock screen and OCR import.
class RestockRepository {
  RestockRepository(this._db);
  final AppDatabase _db;
  final _uuid = const Uuid();

  /// Unresolved restock items for a kitchen, newest first (reactive).
  Stream<List<RestockListItem>> watchActive(String kitchenId) {
    return (_db.select(_db.restockListItems)
          ..where((t) =>
              t.isResolved.equals(false) & t.kitchenId.equals(kitchenId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<void> addManual({
    required String kitchenId,
    required String itemName,
    double? quantity,
    MeasurementUnit? unit,
    String? ingredientId,
    RestockReason reason = RestockReason.manual,
  }) {
    return _db.into(_db.restockListItems).insert(
          RestockListItemsCompanion.insert(
            id: _uuid.v4(),
            kitchenId: Value(kitchenId),
            ingredientId: Value(ingredientId),
            itemName: itemName,
            suggestedQuantity: Value(quantity),
            unit: Value(unit),
            reason: reason,
            addedAt: DateTime.now(),
          ),
        );
  }

  Future<void> setResolved(String id, bool resolved) {
    return (_db.update(_db.restockListItems)..where((t) => t.id.equals(id)))
        .write(RestockListItemsCompanion(isResolved: Value(resolved)));
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.restockListItems)..where((t) => t.id.equals(id))).go();
  }

  /// Clears all resolved items.
  Future<void> clearResolved() {
    return (_db.delete(_db.restockListItems)
          ..where((t) => t.isResolved.equals(true)))
        .go();
  }
}
