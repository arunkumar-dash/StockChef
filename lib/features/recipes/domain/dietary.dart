import '../../../core/database/app_database.dart';

/// Dietary / nutrition-goal tags a recipe can qualify for. Derived from data
/// already stored (the vegetarian flag, the ingredient list, and per-serving
/// nutrition) — no dataset re-authoring or schema change needed.
enum DietaryTag {
  vegetarian,
  nonVegetarian,
  satvik,
  highProtein,
  light, // weight-loss friendly (low calorie)
  hearty, // weight-gain friendly (calorie-dense)
}

extension DietaryTagLabel on DietaryTag {
  String get label => switch (this) {
    DietaryTag.vegetarian => 'Veg',
    DietaryTag.nonVegetarian => 'Non-veg',
    DietaryTag.satvik => 'Satvik',
    DietaryTag.highProtein => 'High protein',
    DietaryTag.light => 'Light',
    DietaryTag.hearty => 'Hearty',
  };
}

/// Thresholds for the nutrition-goal tags (per serving). Tunable in one place.
class DietaryThresholds {
  const DietaryThresholds._();
  static const double highProteinGrams = 12;
  static const double lightMaxCalories = 250;
  static const double heartyMinCalories = 400;
}

/// Ingredients excluded by a satvik diet (onion/garlic family). Satvik also
/// implies vegetarian. Matched against ingredient ids.
const satvikExcludedIngredientIds = {
  'onion',
  'garlic',
  'shallots',
  'ginger_garlic_paste',
  'spring_onion',
};

/// Computes the dietary tags for one recipe given the set of ingredient ids it
/// uses. Pure and side-effect free.
Set<DietaryTag> computeDietaryTags(Recipe recipe, Set<String> ingredientIds) {
  final tags = <DietaryTag>{};

  if (recipe.isVegetarian) {
    tags.add(DietaryTag.vegetarian);
    final hasAllium =
        ingredientIds.any(satvikExcludedIngredientIds.contains);
    if (!hasAllium) tags.add(DietaryTag.satvik);
  } else {
    tags.add(DietaryTag.nonVegetarian);
  }

  final protein = recipe.proteinGrams;
  if (protein != null && protein >= DietaryThresholds.highProteinGrams) {
    tags.add(DietaryTag.highProtein);
  }
  final calories = recipe.caloriesPerServing;
  if (calories != null) {
    if (calories <= DietaryThresholds.lightMaxCalories) tags.add(DietaryTag.light);
    if (calories >= DietaryThresholds.heartyMinCalories) tags.add(DietaryTag.hearty);
  }

  return tags;
}
