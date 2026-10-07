import '../../../core/database/app_database.dart';
import '../domain/recipe_matcher.dart';

/// Loads everything the [RecipeMatcher] needs from the database in a few bulk
/// queries (not per-recipe), then hands over a plain [MatchingInput].
class MatchingRepository {
  MatchingRepository(this._db);
  final AppDatabase _db;

  Future<MatchingInput> loadInput(String kitchenId) async {
    final recipes = await _db.select(_db.recipes).get();
    final allRecipeIngredients = await _db.select(_db.recipeIngredients).get();
    final ingredients = await _db.select(_db.ingredients).get();
    final inventory = await (_db.select(_db.inventoryItems)
          ..where((t) => t.kitchenId.equals(kitchenId)))
        .get();
    final subs = await _db.select(_db.ingredientSubstitutions).get();

    // recipeId -> its ingredients.
    final byRecipe = <String, List<RecipeIngredient>>{};
    for (final ri in allRecipeIngredients) {
      byRecipe.putIfAbsent(ri.recipeId, () => []).add(ri);
    }

    // ingredientId -> name.
    final names = {for (final i in ingredients) i.id: i.name};

    // Owned ingredients -> earliest expiry among non-expired batches
    // (FIFO: surface the soonest-expiring batch).
    final ownedExpiry = <String, DateTime?>{};
    for (final item in inventory) {
      final id = item.ingredientId;
      if (id == null) continue;
      final existing = ownedExpiry[id];
      if (!ownedExpiry.containsKey(id) ||
          (existing != null && item.expiryDate.isBefore(existing))) {
        ownedExpiry[id] = item.expiryDate;
      }
    }

    // ingredientId -> substitution options.
    final subMap = <String, List<SubOption>>{};
    for (final s in subs) {
      subMap
          .putIfAbsent(s.ingredientId, () => [])
          .add(SubOption(s.alternativeIngredientId, s.qualityRatio));
    }

    return MatchingInput(
      recipes: recipes,
      recipeIngredients: byRecipe,
      ingredientNames: names,
      ownedExpiry: ownedExpiry,
      substitutions: subMap,
    );
  }
}
