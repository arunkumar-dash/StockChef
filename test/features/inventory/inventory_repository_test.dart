import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/app_database.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/inventory/data/inventory_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late InventoryRepository repo;

  setUp(() async {
    db = AppDatabase.memory();
    repo = InventoryRepository(db);
    // Seed an ingredient + stock policy (par 1000g, restock < 10%).
    await db.into(db.ingredients).insert(IngredientsCompanion.insert(
          id: 'rice',
          name: 'Rice',
          defaultUnit: MeasurementUnit.grams,
        ));
    await db.into(db.ingredientStockPolicies).insert(
          IngredientStockPoliciesCompanion.insert(
            ingredientId: 'rice',
            parQuantity: 1000,
            unit: MeasurementUnit.grams,
            isCore: const Value(true),
          ),
        );
  });

  tearDown(() => db.close());

  InventoryItemsCompanion batch(String id, double qty, {int expiresInDays = 30}) {
    final now = DateTime.now();
    return InventoryItemsCompanion(
      id: Value(id),
      ingredientId: const Value('rice'),
      quantity: Value(qty),
      unit: const Value(MeasurementUnit.grams),
      purchaseDate: Value(now),
      expiryDate: Value(now.add(Duration(days: expiresInDays))),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  Future<int> activeRestockCount() async {
    final rows = await (db.select(db.restockListItems)
          ..where((t) => t.isResolved.equals(false)))
        .get();
    return rows.length;
  }

  test('does not list when stock is above threshold', () async {
    await repo.upsertBatch(batch('b1', 500)); // 50% of par
    expect(await activeRestockCount(), 0);
  });

  test('auto-lists when aggregate stock drops below threshold', () async {
    await repo.upsertBatch(batch('b1', 50)); // 5% of par -> restock
    expect(await activeRestockCount(), 1);
  });

  test('aggregates across batches before deciding', () async {
    // Both batches stay above threshold; the total (65%) is what matters.
    await repo.upsertBatch(batch('b1', 600)); // 60% -> not listed
    await repo.upsertBatch(batch('b2', 50)); // total 650g = 65% -> still not listed
    expect(await activeRestockCount(), 0);
  });

  test('topping up resolves the auto restock entry (with hysteresis)', () async {
    await repo.upsertBatch(batch('b1', 50)); // 5% -> listed
    expect(await activeRestockCount(), 1);
    await repo.upsertBatch(batch('b2', 150)); // total 200g = 20% -> clears
    expect(await activeRestockCount(), 0);
  });

  test('expired batches do not count toward on-hand', () async {
    await repo.upsertBatch(batch('b1', 500, expiresInDays: -2)); // expired
    // Only expired stock -> effectively 0 on hand -> restock.
    expect(await activeRestockCount(), 1);
  });
}
