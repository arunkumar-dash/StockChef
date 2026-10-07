import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/app_database.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/matching/domain/match_models.dart';
import 'package:stockchef/features/matching/domain/recipe_matcher.dart';

/// Helpers to build minimal fixture rows.
Recipe _recipe(String id) => Recipe(
      id: id,
      name: id,
      cuisine: CuisineRegion.tamil,
      mealType: MealType.lunch,
      baseServings: 1,
      isVegetarian: true,
      isUserCreated: false,
      createdAt: DateTime(2026),
    );

RecipeIngredient _ri(String recipeId, String ingId, {bool optional = false}) =>
    RecipeIngredient(
      id: '${recipeId}_$ingId',
      recipeId: recipeId,
      ingredientId: ingId,
      quantityPerServing: 1,
      unit: MeasurementUnit.grams,
      isOptional: optional,
    );

MatchingInput _input({
  required List<Recipe> recipes,
  required Map<String, List<RecipeIngredient>> ings,
  required Map<String, DateTime?> owned,
  Map<String, List<SubOption>> subs = const {},
  Map<String, String>? names,
}) {
  final allIds = {
    for (final list in ings.values)
      for (final ri in list) ri.ingredientId,
    ...owned.keys,
  };
  return MatchingInput(
    recipes: recipes,
    recipeIngredients: ings,
    ingredientNames: names ?? {for (final id in allIds) id: id},
    ownedExpiry: owned,
    substitutions: subs,
  );
}

void main() {
  const matcher = RecipeMatcher();
  final now = DateTime(2026, 7, 12);

  test('fully owned recipe is MAKEABLE_NOW', () {
    final input = _input(
      recipes: [_recipe('r1')],
      ings: {
        'r1': [_ri('r1', 'a'), _ri('r1', 'b')],
      },
      owned: {'a': null, 'b': null},
    );
    final r = matcher.rank(input, now: now).single;
    expect(r.tier, MatchTier.makeableNow);
    expect(r.completeness, 1.0);
    expect(r.missing, isEmpty);
  });

  test('substitutable ingredient yields MAKEABLE_WITH_SUBSTITUTION', () {
    final input = _input(
      recipes: [_recipe('r1')],
      ings: {
        'r1': [_ri('r1', 'toor'), _ri('r1', 'salt')],
      },
      owned: {'masoor': null, 'salt': null},
      subs: {
        'toor': [const SubOption('masoor', 0.8)],
      },
    );
    final r = matcher.rank(input, now: now).single;
    expect(r.tier, MatchTier.makeableWithSubstitution);
    expect(r.substituted.single.usedId, 'masoor');
    expect(r.missing, isEmpty);
  });

  test('missing ingredient with unavailable substitute is PARTIAL', () {
    final input = _input(
      recipes: [_recipe('r1')],
      ings: {
        'r1': [_ri('r1', 'toor'), _ri('r1', 'salt')],
      },
      owned: {'salt': null},
      subs: {
        'toor': [const SubOption('masoor', 0.8)],
      },
    );
    final r = matcher.rank(input, now: now).single;
    expect(r.tier, MatchTier.partial);
    expect(r.missing.single.ingredientId, 'toor');
    expect(r.missing.single.suggestedSubstituteNames, contains('masoor'));
  });

  test('empty inventory: every recipe is PARTIAL, never crashes', () {
    final input = _input(
      recipes: [_recipe('r1'), _recipe('r2')],
      ings: {
        'r1': [_ri('r1', 'a')],
        'r2': [_ri('r2', 'b')],
      },
      owned: {},
    );
    final ranked = matcher.rank(input, now: now);
    expect(ranked, hasLength(2));
    expect(ranked.every((r) => r.tier == MatchTier.partial), isTrue);
  });

  test('expiring items boost score and are flagged', () {
    final input = _input(
      recipes: [_recipe('fresh'), _recipe('urgent')],
      ings: {
        'fresh': [_ri('fresh', 'a')],
        'urgent': [_ri('urgent', 'b')],
      },
      owned: {
        'a': now.add(const Duration(days: 30)), // fresh
        'b': now.add(const Duration(days: 1)), // expiring soon
      },
    );
    final ranked = matcher.rank(input, now: now);
    // Both makeable now, but the expiring one should rank first.
    expect(ranked.first.recipe.id, 'urgent');
    expect(ranked.first.usesExpiringItems, isTrue);
    expect(ranked.last.usesExpiringItems, isFalse);
  });

  test('optional ingredients are ignored for matchability', () {
    final input = _input(
      recipes: [_recipe('r1')],
      ings: {
        'r1': [_ri('r1', 'a'), _ri('r1', 'garnish', optional: true)],
      },
      owned: {'a': null},
    );
    final r = matcher.rank(input, now: now).single;
    expect(r.tier, MatchTier.makeableNow);
    expect(r.totalRequired, 1);
  });

  test('past-dated (expired) owned item still counts as owned', () {
    final input = _input(
      recipes: [_recipe('r1')],
      ings: {
        'r1': [_ri('r1', 'a')],
      },
      owned: {'a': now.subtract(const Duration(days: 5))},
    );
    final r = matcher.rank(input, now: now).single;
    expect(r.tier, MatchTier.makeableNow);
    // Expired date must not be counted as "expiring soon" urgency.
    expect(r.usesExpiringItems, isFalse);
  });
}
