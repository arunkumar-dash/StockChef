import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/constants/asset_paths.dart';
import 'package:stockchef/core/database/app_database.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/core/seeding/recipe_seeder.dart';

/// Minimal in-memory fixtures mirroring the real asset shapes.
const _ingredientsJson = '''
{ "ingredients": [
  { "id": "toor_dal", "name": "Toor Dal", "defaultUnit": "grams", "parQuantity": 1000, "isCore": true },
  { "id": "masoor_dal", "name": "Masoor Dal", "defaultUnit": "grams" },
  { "id": "salt", "name": "Salt", "defaultUnit": "teaspoons" }
]}''';

const _equipmentJson = '''
{ "equipment": [
  { "id": "pressure_cooker", "name": "Pressure Cooker" },
  { "id": "deep_pot", "name": "Deep Pot" }
]}''';

const _recipesJson = '''
{ "recipes": [
  { "id": "r1", "name": "Test Dal", "cuisine": "tamil", "mealType": "lunch",
    "nutrition": { "calories": 100, "protein": 5 },
    "ingredients": [
      { "ingredientId": "toor_dal", "quantity": 40, "unit": "grams" },
      { "ingredientId": "salt", "quantity": 1, "unit": "teaspoons" }
    ],
    "equipment": [ { "equipmentId": "pressure_cooker", "commonlySubstituted": true } ],
    "steps": [
      { "order": 1, "instruction": "Cook dal", "flame": "high" },
      { "order": 2, "instruction": "Add salt", "flame": "low" }
    ]
  }
]}''';

const _ingredientSubsJson = '''
{ "substitutions": { "toor_dal": [ { "id": "masoor_dal", "quality": 0.8 } ] } }''';

const _equipmentSubsJson = '''
{ "substitutions": { "pressure_cooker": [ { "id": "deep_pot", "note": "cook longer" } ] } }''';

Future<String> _fakeLoader(String path) async => switch (path) {
  AssetPaths.ingredients => _ingredientsJson,
  AssetPaths.equipment => _equipmentJson,
  AssetPaths.recipes => _recipesJson,
  AssetPaths.ingredientSubstitutions => _ingredientSubsJson,
  AssetPaths.equipmentSubstitutions => _equipmentSubsJson,
  _ => throw ArgumentError('unexpected asset $path'),
};

void main() {
  // Silence the multiple-database warning across tests.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  test('seeds ingredients, equipment, recipes and substitutions', () async {
    final ran = await RecipeSeeder(db, loader: _fakeLoader).seedIfNeeded();
    expect(ran, isTrue);

    expect(await db.select(db.ingredients).get(), hasLength(3));
    expect(await db.select(db.equipment).get(), hasLength(2));
    expect(await db.select(db.recipes).get(), hasLength(1));
    expect(await db.select(db.recipeIngredients).get(), hasLength(2));
    expect(await db.select(db.recipeSteps).get(), hasLength(2));
    expect(await db.select(db.ingredientSubstitutions).get(), hasLength(1));
    expect(await db.select(db.equipmentSubstitutions).get(), hasLength(1));

    // Stock policy created only for the ingredient declaring a par level.
    final policies = await db.select(db.ingredientStockPolicies).get();
    expect(policies, hasLength(1));
    expect(policies.single.ingredientId, 'toor_dal');
    expect(policies.single.isCore, isTrue);

    // Nutrition mapped onto the recipe row.
    final recipe = await db.select(db.recipes).getSingle();
    expect(recipe.caloriesPerServing, 100);
    expect(recipe.isUserCreated, isFalse);
  });

  test('is version-gated: second run is a no-op', () async {
    final seeder = RecipeSeeder(db, loader: _fakeLoader);
    expect(await seeder.seedIfNeeded(), isTrue);
    expect(await seeder.seedIfNeeded(), isFalse);
    expect(await db.select(db.recipes).get(), hasLength(1));
  });

  test('re-seed preserves user-created recipes', () async {
    await RecipeSeeder(db, loader: _fakeLoader).seedIfNeeded();

    // Simulate a user-authored recipe.
    await db
        .into(db.recipes)
        .insert(
          RecipesCompanion.insert(
            id: 'user_1',
            name: 'My Recipe',
            cuisine: CuisineRegion.other,
            mealType: MealType.dinner,
            createdAt: DateTime(2026, 1, 1),
            isUserCreated: const Value(true),
          ),
        );

    // Force a re-seed by clearing the version marker.
    await (db.delete(db.seedMetadata)).go();
    await RecipeSeeder(db, loader: _fakeLoader).seedIfNeeded();

    final recipes = await db.select(db.recipes).get();
    expect(recipes.where((r) => r.isUserCreated), hasLength(1));
    expect(recipes.where((r) => !r.isUserCreated), hasLength(1));
  });
}
