import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/recipe_repository.dart';
import '../domain/dietary.dart';
import '../domain/entities/recipe_detail.dart';

/// Repository singleton, wired to the app database.
final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepository(ref.watch(databaseProvider)),
);

/// All recipes for the browse list (reactive).
final recipeListProvider = StreamProvider<List<Recipe>>(
  (ref) => ref.watch(recipeRepositoryProvider).watchAllRecipes(),
);

/// A fully-loaded recipe for the detail screen, keyed by recipe id.
final recipeDetailProvider = FutureProvider.family<RecipeDetail?, String>(
  (ref, id) => ref.watch(recipeRepositoryProvider).getRecipeDetail(id),
);

/// The serving-size selection on the detail screen, keyed by recipe id.
/// Defaults to 2 servings.
final servingsProvider = StateProvider.family<int, String>((ref, id) => 2);

/// Dietary tags per recipe id, derived from the vegetarian flag, ingredient
/// list and nutrition. Recomputes when recipes change.
final recipeDietaryTagsProvider =
    FutureProvider<Map<String, Set<DietaryTag>>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  ref.watch(recipeListProvider); // recompute when the recipe set changes
  final recipes = await repo.getAllRecipes();
  final ingredientIds = await repo.recipeIngredientIds();
  return {
    for (final r in recipes)
      r.id: computeDietaryTags(r, ingredientIds[r.id] ?? const {}),
  };
});
