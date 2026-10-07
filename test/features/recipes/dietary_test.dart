import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/app_database.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/recipes/domain/dietary.dart';

Recipe _recipe({
  bool veg = true,
  double? protein,
  double? calories,
}) =>
    Recipe(
      id: 'r',
      name: 'r',
      cuisine: CuisineRegion.tamil,
      mealType: MealType.lunch,
      baseServings: 1,
      isVegetarian: veg,
      isUserCreated: false,
      createdAt: DateTime(2026),
      proteinGrams: protein,
      caloriesPerServing: calories,
    );

void main() {
  test('vegetarian without alliums is satvik', () {
    final tags = computeDietaryTags(_recipe(veg: true), {'toor_dal', 'rice'});
    expect(tags, contains(DietaryTag.vegetarian));
    expect(tags, contains(DietaryTag.satvik));
    expect(tags, isNot(contains(DietaryTag.nonVegetarian)));
  });

  test('vegetarian with onion/garlic is NOT satvik', () {
    final tags = computeDietaryTags(_recipe(veg: true), {'onion', 'toor_dal'});
    expect(tags, contains(DietaryTag.vegetarian));
    expect(tags, isNot(contains(DietaryTag.satvik)));
  });

  test('non-vegetarian is tagged non-veg and never satvik', () {
    final tags = computeDietaryTags(_recipe(veg: false), {'chicken'});
    expect(tags, contains(DietaryTag.nonVegetarian));
    expect(tags, isNot(contains(DietaryTag.vegetarian)));
    expect(tags, isNot(contains(DietaryTag.satvik)));
  });

  test('high protein / light / hearty derive from nutrition thresholds', () {
    expect(
      computeDietaryTags(_recipe(protein: 15), {'x'}),
      contains(DietaryTag.highProtein),
    );
    expect(
      computeDietaryTags(_recipe(calories: 200), {'x'}),
      contains(DietaryTag.light),
    );
    expect(
      computeDietaryTags(_recipe(calories: 500), {'x'}),
      contains(DietaryTag.hearty),
    );
    // A mid-calorie, low-protein recipe gets none of the goal tags.
    final none = computeDietaryTags(_recipe(protein: 5, calories: 300), {'x'});
    expect(none, isNot(contains(DietaryTag.highProtein)));
    expect(none, isNot(contains(DietaryTag.light)));
    expect(none, isNot(contains(DietaryTag.hearty)));
  });
}
