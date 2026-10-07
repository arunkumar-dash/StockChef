import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../domain/entities/recipe_detail.dart';

/// A single ingredient line entered by the user when authoring a recipe.
class DraftRecipeIngredient {
  DraftRecipeIngredient({
    required this.ingredientId,
    required this.quantity,
    required this.unit,
    this.note,
  });
  String ingredientId;
  double quantity;
  MeasurementUnit unit;
  String? note;
}

/// A single step entered by the user when authoring a recipe.
class DraftRecipeStep {
  DraftRecipeStep({required this.instruction, this.flame});
  String instruction;
  GasFlameLevel? flame;
}

/// Reads recipes and their child rows from the database. Kept as a plain class
/// (wrapping [AppDatabase]) rather than a generated DAO to avoid a second
/// codegen surface; queries use Drift's typed query API.
class RecipeRepository {
  RecipeRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Creates a new user-authored recipe (always `isUserCreated = true`).
  /// Returns the new recipe id.
  Future<String> saveUserRecipe({
    required String name,
    String? description,
    required CuisineRegion cuisine,
    required MealType mealType,
    required bool isVegetarian,
    required List<DraftRecipeIngredient> ingredients,
    required List<DraftRecipeStep> steps,
    double? calories,
  }) async {
    final id = 'user_${_uuid.v4()}';
    await _db.transaction(() async {
      await _db.into(_db.recipes).insert(RecipesCompanion.insert(
            id: id,
            name: name,
            cuisine: cuisine,
            mealType: mealType,
            createdAt: DateTime.now(),
            description: Value(description),
            isVegetarian: Value(isVegetarian),
            isUserCreated: const Value(true),
            caloriesPerServing: Value(calories),
          ));
      for (var i = 0; i < ingredients.length; i++) {
        final di = ingredients[i];
        await _db.into(_db.recipeIngredients).insert(
              RecipeIngredientsCompanion.insert(
                id: '${id}__ing_$i',
                recipeId: id,
                ingredientId: di.ingredientId,
                quantityPerServing: di.quantity,
                unit: di.unit,
                preparationNote: Value(di.note),
              ),
            );
      }
      for (var i = 0; i < steps.length; i++) {
        final ds = steps[i];
        await _db.into(_db.recipeSteps).insert(RecipeStepsCompanion.insert(
              id: '${id}__step_$i',
              recipeId: id,
              orderIndex: i + 1,
              instruction: ds.instruction,
              flameLevel: Value(ds.flame),
            ));
      }
    });
    return id;
  }

  /// Deletes a recipe — but only if it is user-created. Bundled recipes are
  /// read-only by construction (throws if you try to delete one).
  Future<void> deleteUserRecipe(String recipeId) async {
    final recipe = await (_db.select(_db.recipes)
          ..where((t) => t.id.equals(recipeId)))
        .getSingleOrNull();
    if (recipe == null) return;
    if (!recipe.isUserCreated) {
      throw StateError('Bundled recipes are read-only and cannot be deleted');
    }
    await _db.transaction(() async {
      await (_db.delete(_db.recipeIngredients)
            ..where((t) => t.recipeId.equals(recipeId)))
          .go();
      await (_db.delete(_db.recipeSteps)..where((t) => t.recipeId.equals(recipeId)))
          .go();
      await (_db.delete(_db.recipeEquipments)
            ..where((t) => t.recipeId.equals(recipeId)))
          .go();
      await (_db.delete(_db.recipes)..where((t) => t.id.equals(recipeId))).go();
    });
  }

  /// All recipes, newest user-created first, then alphabetical. Lightweight —
  /// used for the browse list.
  Future<List<Recipe>> getAllRecipes() {
    return (_db.select(_db.recipes)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isUserCreated, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .get();
  }

  /// Maps every recipe id to the set of ingredient ids it uses. Used to derive
  /// dietary tags (e.g. satvik = no onion/garlic) without per-recipe queries.
  Future<Map<String, Set<String>>> recipeIngredientIds() async {
    final rows = await _db.select(_db.recipeIngredients).get();
    final map = <String, Set<String>>{};
    for (final r in rows) {
      map.putIfAbsent(r.recipeId, () => <String>{}).add(r.ingredientId);
    }
    return map;
  }

  /// Watches all recipes reactively (list auto-refreshes when data changes).
  Stream<List<Recipe>> watchAllRecipes() {
    return (_db.select(_db.recipes)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  /// Loads a recipe with all children joined for the detail screen. Returns
  /// null if the id is unknown.
  Future<RecipeDetail?> getRecipeDetail(String recipeId) async {
    final recipe = await (_db.select(_db.recipes)
          ..where((t) => t.id.equals(recipeId)))
        .getSingleOrNull();
    if (recipe == null) return null;

    final ingredients = await _ingredientsFor(recipeId);
    final steps = await (_db.select(_db.recipeSteps)
          ..where((t) => t.recipeId.equals(recipeId))
          ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
        .get();
    final equipment = await _equipmentFor(recipeId);

    return RecipeDetail(
      recipe: recipe,
      ingredients: ingredients,
      steps: steps,
      equipment: equipment,
    );
  }

  Future<List<RecipeIngredientView>> _ingredientsFor(String recipeId) async {
    final query = _db.select(_db.recipeIngredients).join([
      leftOuterJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.recipeIngredients.ingredientId),
      ),
    ])..where(_db.recipeIngredients.recipeId.equals(recipeId));

    final rows = await query.get();
    return rows
        .map((r) => RecipeIngredientView(
              line: r.readTable(_db.recipeIngredients),
              ingredient: r.readTableOrNull(_db.ingredients),
            ))
        .toList();
  }

  Future<List<RecipeEquipmentView>> _equipmentFor(String recipeId) async {
    final query = _db.select(_db.recipeEquipments).join([
      leftOuterJoin(
        _db.equipment,
        _db.equipment.id.equalsExp(_db.recipeEquipments.equipmentId),
      ),
    ])..where(_db.recipeEquipments.recipeId.equals(recipeId));

    final rows = await query.get();
    final views = <RecipeEquipmentView>[];
    for (final r in rows) {
      final line = r.readTable(_db.recipeEquipments);
      final substitutes = await _equipmentAlternatives(line.equipmentId);
      views.add(RecipeEquipmentView(
        line: line,
        equipment: r.readTableOrNull(_db.equipment),
        substitutes: substitutes,
      ));
    }
    return views;
  }

  Future<List<EquipmentAlternative>> _equipmentAlternatives(
    String equipmentId,
  ) async {
    final query = _db.select(_db.equipmentSubstitutions).join([
      leftOuterJoin(
        _db.equipment,
        _db.equipment.id.equalsExp(_db.equipmentSubstitutions.alternativeEquipmentId),
      ),
    ])..where(_db.equipmentSubstitutions.equipmentId.equals(equipmentId));

    final rows = await query.get();
    return rows.map((r) {
      final sub = r.readTable(_db.equipmentSubstitutions);
      final alt = r.readTableOrNull(_db.equipment);
      return EquipmentAlternative(
        name: alt?.name ?? sub.alternativeEquipmentId,
        note: sub.note,
      );
    }).toList();
  }
}
