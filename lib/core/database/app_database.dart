import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'enums.dart';
import 'tables/inventory_tables.dart';
import 'tables/recipe_tables.dart';
import 'tables/reference_tables.dart';
import 'tables/system_tables.dart';

part 'app_database.g.dart';

/// The single Drift database for the whole app. All feature DAOs are generated
/// from the tables listed here. Open the real on-device database with the
/// default constructor; pass an in-memory executor in tests.
@DriftDatabase(
  tables: [
    // reference / dictionary
    Ingredients,
    Equipment,
    IngredientSubstitutions,
    EquipmentSubstitutions,
    IngredientStockPolicies,
    // recipes
    Recipes,
    RecipeIngredients,
    RecipeEquipments,
    RecipeSteps,
    // inventory & restock
    InventoryItems,
    RestockListItems,
    CookEvents,
    // system
    ScheduledReminders,
    NotificationDebounces,
    SeedMetadata,
    Kitchens,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Convenience for tests: an isolated in-memory database.
  AppDatabase.memory() : super(NativeDatabase.memory());

  /// The permanent default kitchen id.
  static const String homeKitchenId = 'home';

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Guest-mode: kitchens + per-kitchen scoping.
            await m.createTable(kitchens);
            await m.addColumn(inventoryItems, inventoryItems.kitchenId);
            await m.addColumn(restockListItems, restockListItems.kitchenId);
          }
          if (from < 3) {
            // Persisted app preferences (theme mode).
            await m.createTable(appSettings);
          }
        },
        beforeOpen: (details) async {
          // Ensure the permanent "home" kitchen always exists.
          await into(kitchens).insert(
            KitchensCompanion.insert(
              id: homeKitchenId,
              name: 'Home',
              createdAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'stockchef.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
