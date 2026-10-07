import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

/// Manages kitchens (inventory spaces). "home" is permanent; a "guest" kitchen
/// supports the travel/Airbnb use case. Clearing a kitchen wipes only its
/// inventory + restock rows — recipes and dictionaries are shared.
class KitchenRepository {
  KitchenRepository(this._db);
  final AppDatabase _db;

  static const guestKitchenId = 'guest';

  Stream<List<Kitchen>> watchKitchens() {
    return (_db.select(_db.kitchens)
          ..orderBy([
            // Home first, then others by creation.
            (t) => OrderingTerm(expression: t.isGuest),
            (t) => OrderingTerm(expression: t.createdAt),
          ]))
        .watch();
  }

  Future<List<Kitchen>> getKitchens() => _db.select(_db.kitchens).get();

  /// Creates the guest kitchen if it doesn't exist yet; returns its id.
  Future<String> ensureGuestKitchen() async {
    await _db.into(_db.kitchens).insert(
          KitchensCompanion.insert(
            id: guestKitchenId,
            name: 'Guest kitchen',
            isGuest: const Value(true),
            createdAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return guestKitchenId;
  }

  /// Removes all inventory and restock entries for a kitchen (used by
  /// "clear guest kitchen" when leaving a rental). Does not delete the
  /// permanent home kitchen's row.
  Future<void> clearKitchen(String kitchenId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.inventoryItems)
            ..where((t) => t.kitchenId.equals(kitchenId)))
          .go();
      await (_db.delete(_db.restockListItems)
            ..where((t) => t.kitchenId.equals(kitchenId)))
          .go();
    });
  }
}
