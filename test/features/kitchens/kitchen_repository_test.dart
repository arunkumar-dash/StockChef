import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/app_database.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/inventory/data/inventory_repository.dart';
import 'package:stockchef/features/kitchens/data/kitchen_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late InventoryRepository inventory;
  late KitchenRepository kitchens;

  InventoryItemsCompanion batch(String id, String kitchenId) {
    final now = DateTime.now();
    return InventoryItemsCompanion(
      id: Value(id),
      kitchenId: Value(kitchenId),
      ingredientId: const Value('rice'),
      quantity: const Value(500),
      unit: const Value(MeasurementUnit.grams),
      purchaseDate: Value(now),
      expiryDate: Value(now.add(const Duration(days: 30))),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  setUp(() async {
    db = AppDatabase.memory();
    inventory = InventoryRepository(db);
    kitchens = KitchenRepository(db);
    await db.into(db.ingredients).insert(IngredientsCompanion.insert(
          id: 'rice',
          name: 'Rice',
          defaultUnit: MeasurementUnit.grams,
        ));
  });
  tearDown(() => db.close());

  test('inventory is isolated per kitchen', () async {
    await kitchens.ensureGuestKitchen();
    await inventory.upsertBatch(batch('h1', AppDatabase.homeKitchenId));
    await inventory.upsertBatch(batch('g1', KitchenRepository.guestKitchenId));

    final home =
        await inventory.watchStockViews(AppDatabase.homeKitchenId).first;
    final guest =
        await inventory.watchStockViews(KitchenRepository.guestKitchenId).first;

    expect(home, hasLength(1));
    expect(guest, hasLength(1));
    expect(home.single.batches.single.batch.id, 'h1');
    expect(guest.single.batches.single.batch.id, 'g1');
  });

  test('clearing the guest kitchen leaves home untouched', () async {
    await kitchens.ensureGuestKitchen();
    await inventory.upsertBatch(batch('h1', AppDatabase.homeKitchenId));
    await inventory.upsertBatch(batch('g1', KitchenRepository.guestKitchenId));

    await kitchens.clearKitchen(KitchenRepository.guestKitchenId);

    final home =
        await inventory.watchStockViews(AppDatabase.homeKitchenId).first;
    final guest =
        await inventory.watchStockViews(KitchenRepository.guestKitchenId).first;
    expect(home, hasLength(1));
    expect(guest, isEmpty);
  });

  test('home kitchen exists by default (beforeOpen seed)', () async {
    final all = await kitchens.getKitchens();
    expect(all.any((k) => k.id == AppDatabase.homeKitchenId), isTrue);
  });
}
