import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../constants/asset_paths.dart';
import '../database/app_database.dart';
import 'seed_dtos.dart';

/// Signature for loading a bundled asset as a string. Overridable in tests so
/// the seeder can run against in-memory fixtures without the asset bundle.
typedef AssetLoader = Future<String> Function(String path);

Future<String> _defaultLoader(String path) => rootBundle.loadString(path);

/// Populates the database from the bundled JSON dataset on first run (and after
/// the dataset version bumps). Idempotent and version-gated: user-created
/// recipes are never touched.
class RecipeSeeder {
  RecipeSeeder(this.db, {AssetLoader loader = _defaultLoader})
    : _loader = loader;

  final AppDatabase db;
  final AssetLoader _loader;

  /// Bump this when the bundled JSON changes to force a re-seed.
  static const int datasetVersion = 3;
  static const String _versionKey = 'dataset_version';

  /// Seeds if needed. Returns true if a (re)seed ran, false if already current.
  Future<bool> seedIfNeeded() async {
    final current = await _currentVersion();
    if (current == datasetVersion) return false;
    await _seed();
    return true;
  }

  Future<int?> _currentVersion() async {
    final row = await (db.select(
      db.seedMetadata,
    )..where((t) => t.key.equals(_versionKey))).getSingleOrNull();
    return row == null ? null : int.tryParse(row.value);
  }

  Future<void> _seed() async {
    // Parse everything up front (outside the transaction) so a malformed asset
    // fails fast without partially mutating the DB.
    final ingredients = await _loadIngredients();
    final equipment = await _loadEquipment();
    final recipes = await _loadRecipes();
    final ingredientSubs = await _loadSubstitutions(
      AssetPaths.ingredientSubstitutions,
    );
    final equipmentSubs = await _loadSubstitutions(
      AssetPaths.equipmentSubstitutions,
    );

    await db.transaction(() async {
      await _replaceBundledRecipes(recipes);
      await _upsertIngredients(ingredients);
      await _upsertEquipment(equipment);
      await _upsertIngredientSubstitutions(ingredientSubs);
      await _upsertEquipmentSubstitutions(equipmentSubs);
      await _insertRecipeGraph(recipes);
      // Link any existing inventory rows that were saved as free-text custom
      // names but now match a canonical ingredient by name.
      await _linkOrphanedInventoryItems();
      await db
          .into(db.seedMetadata)
          .insertOnConflictUpdate(
            SeedMetadataCompanion.insert(
              key: _versionKey,
              value: datasetVersion.toString(),
            ),
          );
    });
  }

  // --- asset parsing -------------------------------------------------------

  Future<List<IngredientSeed>> _loadIngredients() async {
    final json = jsonDecode(await _loader(AssetPaths.ingredients));
    final list = (json is Map ? json['ingredients'] : json) as List;
    return list
        .map((e) => IngredientSeed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<EquipmentSeed>> _loadEquipment() async {
    final json = jsonDecode(await _loader(AssetPaths.equipment));
    final list = (json is Map ? json['equipment'] : json) as List;
    return list
        .map((e) => EquipmentSeed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<RecipeSeed>> _loadRecipes() async {
    final json = jsonDecode(await _loader(AssetPaths.recipes));
    final list = (json is Map ? json['recipes'] : json) as List;
    return list
        .map((e) => RecipeSeed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, List<SubstitutionSeed>>> _loadSubstitutions(
    String path,
  ) async {
    final json = jsonDecode(await _loader(path));
    final map = (json is Map && json.containsKey('substitutions')
        ? json['substitutions']
        : json) as Map<String, dynamic>;
    return map.map(
      (key, value) => MapEntry(
        key,
        (value as List)
            .map((e) => SubstitutionSeed.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  // --- writes --------------------------------------------------------------

  /// Deletes bundled recipes and their child rows (leaving user recipes),
  /// so a re-seed cleanly reflects added/removed/edited bundled recipes.
  Future<void> _replaceBundledRecipes(List<RecipeSeed> _) async {
    final bundledIds =
        await (db.selectOnly(db.recipes)
              ..addColumns([db.recipes.id])
              ..where(db.recipes.isUserCreated.equals(false)))
            .map((r) => r.read(db.recipes.id)!)
            .get();
    if (bundledIds.isEmpty) return;
    await (db.delete(
      db.recipeIngredients,
    )..where((t) => t.recipeId.isIn(bundledIds))).go();
    await (db.delete(
      db.recipeEquipments,
    )..where((t) => t.recipeId.isIn(bundledIds))).go();
    await (db.delete(
      db.recipeSteps,
    )..where((t) => t.recipeId.isIn(bundledIds))).go();
    await (db.delete(
      db.recipes,
    )..where((t) => t.isUserCreated.equals(false))).go();
  }

  Future<void> _upsertIngredients(List<IngredientSeed> items) async {
    await db.batch((b) {
      b.insertAllOnConflictUpdate(db.ingredients, [
        for (final i in items)
          IngredientsCompanion.insert(
            id: i.id,
            name: i.name,
            defaultUnit: i.defaultUnit,
            category: Value(i.category),
          ),
      ]);
      // Seed a stock policy for ingredients that declare a par level.
      b.insertAllOnConflictUpdate(db.ingredientStockPolicies, [
        for (final i in items)
          if (i.parQuantity != null)
            IngredientStockPoliciesCompanion.insert(
              ingredientId: i.id,
              parQuantity: i.parQuantity!,
              unit: i.defaultUnit,
              isCore: Value(i.isCore),
            ),
      ]);
    });
  }

  Future<void> _upsertEquipment(List<EquipmentSeed> items) async {
    await db.batch((b) {
      b.insertAllOnConflictUpdate(db.equipment, [
        for (final e in items)
          EquipmentCompanion.insert(id: e.id, name: e.name),
      ]);
    });
  }

  Future<void> _upsertIngredientSubstitutions(
    Map<String, List<SubstitutionSeed>> subs,
  ) async {
    await db.batch((b) {
      for (final entry in subs.entries) {
        for (final s in entry.value) {
          b.insert(
            db.ingredientSubstitutions,
            IngredientSubstitutionsCompanion.insert(
              id: '${entry.key}__${s.id}',
              ingredientId: entry.key,
              alternativeIngredientId: s.id,
              qualityRatio: Value(s.quality),
              note: Value(s.note),
            ),
            onConflict: DoUpdate(
              (_) => IngredientSubstitutionsCompanion.custom(
                qualityRatio: Constant(s.quality),
              ),
            ),
          );
        }
      }
    });
  }

  Future<void> _upsertEquipmentSubstitutions(
    Map<String, List<SubstitutionSeed>> subs,
  ) async {
    await db.batch((b) {
      for (final entry in subs.entries) {
        for (final s in entry.value) {
          b.insertAllOnConflictUpdate(db.equipmentSubstitutions, [
            EquipmentSubstitutionsCompanion.insert(
              id: '${entry.key}__${s.id}',
              equipmentId: entry.key,
              alternativeEquipmentId: s.id,
              note: Value(s.note),
            ),
          ]);
        }
      }
    });
  }

  /// For every inventory batch that has no [ingredientId] (was typed as free
  /// text), look up the canonical ingredient by a case-insensitive name match
  /// and fill in the [ingredientId]. Safe to run repeatedly (no-op when the
  /// batch already has a linked ingredient).
  Future<void> _linkOrphanedInventoryItems() async {
    // Fetch all unlinked batches that have a customName.
    final orphans =
        await (db.select(db.inventoryItems)
              ..where(
                (t) =>
                    t.ingredientId.isNull() & t.customName.isNotNull(),
              ))
            .get();
    if (orphans.isEmpty) return;

    // Build a lowercase name→id lookup from the canonical ingredient table.
    final allIngredients = await db.select(db.ingredients).get();
    final nameToId = <String, String>{
      for (final ing in allIngredients) ing.name.toLowerCase(): ing.id,
    };

    // Update each orphan whose customName exactly matches a canonical name.
    for (final batch in orphans) {
      final matched = nameToId[batch.customName!.toLowerCase()];
      if (matched != null) {
        await (db.update(db.inventoryItems)
              ..where((t) => t.id.equals(batch.id)))
            .write(InventoryItemsCompanion(ingredientId: Value(matched)));
      }
    }
  }

  Future<void> _insertRecipeGraph(List<RecipeSeed> recipes) async {
    final now = DateTime.now();
    await db.batch((b) {
      for (final r in recipes) {
        b.insert(
          db.recipes,
          RecipesCompanion.insert(
            id: r.id,
            name: r.name,
            cuisine: r.cuisine,
            mealType: r.mealType,
            createdAt: now,
            description: Value(r.description),
            prepTimeMinutes: Value(r.prepTimeMinutes),
            cookTimeMinutes: Value(r.cookTimeMinutes),
            isVegetarian: Value(r.isVegetarian),
            caloriesPerServing: Value(r.nutrition?.calories),
            proteinGrams: Value(r.nutrition?.protein),
            carbsGrams: Value(r.nutrition?.carbs),
            fatGrams: Value(r.nutrition?.fat),
            fiberGrams: Value(r.nutrition?.fiber),
          ),
        );
        for (var i = 0; i < r.ingredients.length; i++) {
          final ri = r.ingredients[i];
          b.insert(
            db.recipeIngredients,
            RecipeIngredientsCompanion.insert(
              id: '${r.id}__ing_$i',
              recipeId: r.id,
              ingredientId: ri.ingredientId,
              quantityPerServing: ri.quantity,
              unit: ri.unit,
              isOptional: Value(ri.optional),
              preparationNote: Value(ri.prep),
            ),
          );
        }
        for (var i = 0; i < r.equipment.length; i++) {
          final re = r.equipment[i];
          b.insert(
            db.recipeEquipments,
            RecipeEquipmentsCompanion.insert(
              id: '${r.id}__eq_$i',
              recipeId: r.id,
              equipmentId: re.equipmentId,
              isEssential: Value(re.essential),
              commonlySubstituted: Value(re.commonlySubstituted),
            ),
          );
        }
        for (var i = 0; i < r.steps.length; i++) {
          final st = r.steps[i];
          b.insert(
            db.recipeSteps,
            RecipeStepsCompanion.insert(
              id: '${r.id}__step_$i',
              recipeId: r.id,
              orderIndex: st.order,
              instruction: st.instruction,
              stepGroupId: Value(st.group),
              flameLevel: Value(st.flame),
              estimatedDurationSeconds: Value(st.durationSeconds),
            ),
          );
        }
      }
    });
  }
}
