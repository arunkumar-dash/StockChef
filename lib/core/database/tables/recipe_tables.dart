import 'package:drift/drift.dart';

import '../enums.dart';

/// A recipe. Bundled recipes have [isUserCreated] = false and are read-only;
/// user-authored recipes set it true. Nutrition values are per serving and are
/// approximate estimates (no nutrition API — surfaced as such in the UI).
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get cuisine => textEnum<CuisineRegion>()();
  TextColumn get mealType => textEnum<MealType>()();

  /// Servings the stored quantities correspond to. Recipes are authored
  /// per-person, so this is 1 by default.
  IntColumn get baseServings => integer().withDefault(const Constant(1))();

  IntColumn get prepTimeMinutes => integer().nullable()();
  IntColumn get cookTimeMinutes => integer().nullable()();
  TextColumn get imageAssetPath => text().nullable()();

  // Nutrition (per serving, approximate).
  RealColumn get caloriesPerServing => real().nullable()();
  RealColumn get proteinGrams => real().nullable()();
  RealColumn get carbsGrams => real().nullable()();
  RealColumn get fatGrams => real().nullable()();
  RealColumn get fiberGrams => real().nullable()();

  BoolColumn get isVegetarian => boolean().withDefault(const Constant(true))();
  BoolColumn get isUserCreated =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A required ingredient for a recipe, with the quantity for ONE serving.
class RecipeIngredients extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  TextColumn get ingredientId => text()();

  /// Quantity for a single serving; scaled up by [PortionScaler].
  RealColumn get quantityPerServing => real()();
  TextColumn get unit => textEnum<MeasurementUnit>()();
  BoolColumn get isOptional => boolean().withDefault(const Constant(false))();

  /// Free-text prep note, e.g. "finely chopped", "soaked 30 min".
  TextColumn get preparationNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Equipment a recipe uses.
class RecipeEquipments extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  TextColumn get equipmentId => text()();

  /// If false, the recipe can be made without it (nice-to-have).
  BoolColumn get isEssential => boolean().withDefault(const Constant(true))();

  /// When true, always show substitute alternatives as a footnote even if the
  /// user isn't tracking equipment ownership.
  BoolColumn get commonlySubstituted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// An ordered cooking step. Steps sharing a non-null [stepGroupId] can be done
/// in parallel. [flameLevel] is set only for on-stove steps.
class RecipeSteps extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get instruction => text()();

  /// Steps with the same group id are parallelizable ("while X simmers, do Y").
  TextColumn get stepGroupId => text().nullable()();
  TextColumn get flameLevel => textEnum<GasFlameLevel>().nullable()();
  IntColumn get estimatedDurationSeconds => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
