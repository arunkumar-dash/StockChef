import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/app_database.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/recipes/data/recipe_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late RecipeRepository repo;

  setUp(() async {
    db = AppDatabase.memory();
    repo = RecipeRepository(db);
    await db.into(db.ingredients).insert(IngredientsCompanion.insert(
          id: 'rice',
          name: 'Rice',
          defaultUnit: MeasurementUnit.grams,
        ));
  });
  tearDown(() => db.close());

  test('saveUserRecipe writes recipe + children, flagged user-created', () async {
    final id = await repo.saveUserRecipe(
      name: 'My Rice',
      cuisine: CuisineRegion.other,
      mealType: MealType.lunch,
      isVegetarian: true,
      ingredients: [
        DraftRecipeIngredient(
            ingredientId: 'rice', quantity: 100, unit: MeasurementUnit.grams),
      ],
      steps: [DraftRecipeStep(instruction: 'Cook rice', flame: GasFlameLevel.high)],
    );

    final detail = await repo.getRecipeDetail(id);
    expect(detail, isNotNull);
    expect(detail!.recipe.isUserCreated, isTrue);
    expect(detail.ingredients, hasLength(1));
    expect(detail.steps, hasLength(1));
  });

  test('deleteUserRecipe removes a user recipe and its children', () async {
    final id = await repo.saveUserRecipe(
      name: 'Temp',
      cuisine: CuisineRegion.other,
      mealType: MealType.snack,
      isVegetarian: true,
      ingredients: [
        DraftRecipeIngredient(
            ingredientId: 'rice', quantity: 1, unit: MeasurementUnit.grams),
      ],
      steps: [DraftRecipeStep(instruction: 'x')],
    );
    await repo.deleteUserRecipe(id);
    expect(await repo.getRecipeDetail(id), isNull);
    expect(await db.select(db.recipeIngredients).get(), isEmpty);
  });

  test('deleteUserRecipe refuses to delete a bundled recipe', () async {
    await db.into(db.recipes).insert(RecipesCompanion.insert(
          id: 'bundled_1',
          name: 'Bundled',
          cuisine: CuisineRegion.tamil,
          mealType: MealType.lunch,
          createdAt: DateTime(2026),
          isUserCreated: const Value(false),
        ));
    expect(
      () => repo.deleteUserRecipe('bundled_1'),
      throwsA(isA<StateError>()),
    );
  });
}
