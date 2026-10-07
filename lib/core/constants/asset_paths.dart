/// Paths to bundled JSON data assets. Kept in one place so the seeder and any
/// tooling agree on filenames.
class AssetPaths {
  const AssetPaths._();

  static const ingredients = 'assets/data/ingredients.json';
  static const equipment = 'assets/data/equipment.json';
  static const recipes = 'assets/data/recipes.json';
  static const ingredientSubstitutions =
      'assets/data/ingredient_substitutions.json';
  static const equipmentSubstitutions =
      'assets/data/equipment_substitutions.json';
}
