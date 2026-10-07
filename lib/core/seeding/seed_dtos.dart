import '../database/enums.dart';

/// Plain data-transfer objects mirroring the bundled JSON asset shapes.
///
/// These are parsed once at seed time and thrown away, so they use hand-written
/// `fromJson` factories rather than codegen — keeping Drift as the project's
/// only code generator and making the JSON contract easy to read in one place.

T _enumByName<T>(List<T> values, String raw, T fallback) {
  for (final v in values) {
    if ((v as Enum).name == raw) return v;
  }
  return fallback;
}

MeasurementUnit _unit(String? raw) =>
    raw == null ? MeasurementUnit.pieces
    : _enumByName(MeasurementUnit.values, raw, MeasurementUnit.pieces);

class IngredientSeed {
  IngredientSeed({
    required this.id,
    required this.name,
    this.category,
    required this.defaultUnit,
    this.aliases = const [],
    this.parQuantity,
    this.isCore = false,
  });

  final String id;
  final String name;
  final String? category;
  final MeasurementUnit defaultUnit;
  final List<String> aliases;

  /// Optional par level + core flag → seeds an [IngredientStockPolicies] row.
  final double? parQuantity;
  final bool isCore;

  factory IngredientSeed.fromJson(Map<String, dynamic> j) => IngredientSeed(
    id: j['id'] as String,
    name: j['name'] as String,
    category: j['category'] as String?,
    defaultUnit: _unit(j['defaultUnit'] as String?),
    aliases:
        (j['aliases'] as List?)?.map((e) => e as String).toList() ?? const [],
    parQuantity: (j['parQuantity'] as num?)?.toDouble(),
    isCore: j['isCore'] as bool? ?? false,
  );
}

class EquipmentSeed {
  EquipmentSeed({required this.id, required this.name, this.aliases = const []});

  final String id;
  final String name;
  final List<String> aliases;

  factory EquipmentSeed.fromJson(Map<String, dynamic> j) => EquipmentSeed(
    id: j['id'] as String,
    name: j['name'] as String,
    aliases:
        (j['aliases'] as List?)?.map((e) => e as String).toList() ?? const [],
  );
}

class RecipeIngredientSeed {
  RecipeIngredientSeed({
    required this.ingredientId,
    required this.quantity,
    required this.unit,
    this.optional = false,
    this.prep,
  });

  final String ingredientId;
  final double quantity;
  final MeasurementUnit unit;
  final bool optional;
  final String? prep;

  factory RecipeIngredientSeed.fromJson(Map<String, dynamic> j) =>
      RecipeIngredientSeed(
        ingredientId: j['ingredientId'] as String,
        quantity: (j['quantity'] as num).toDouble(),
        unit: _unit(j['unit'] as String?),
        optional: j['optional'] as bool? ?? false,
        prep: j['prep'] as String?,
      );
}

class RecipeEquipmentSeed {
  RecipeEquipmentSeed({
    required this.equipmentId,
    this.essential = true,
    this.commonlySubstituted = false,
  });

  final String equipmentId;
  final bool essential;
  final bool commonlySubstituted;

  factory RecipeEquipmentSeed.fromJson(Map<String, dynamic> j) =>
      RecipeEquipmentSeed(
        equipmentId: j['equipmentId'] as String,
        essential: j['essential'] as bool? ?? true,
        commonlySubstituted: j['commonlySubstituted'] as bool? ?? false,
      );
}

class RecipeStepSeed {
  RecipeStepSeed({
    required this.order,
    required this.instruction,
    this.flame,
    this.group,
    this.durationSeconds,
  });

  final int order;
  final String instruction;
  final GasFlameLevel? flame;
  final String? group;
  final int? durationSeconds;

  factory RecipeStepSeed.fromJson(Map<String, dynamic> j) => RecipeStepSeed(
    order: j['order'] as int,
    instruction: j['instruction'] as String,
    flame: j['flame'] == null
        ? null
        : _enumByName(
            GasFlameLevel.values,
            j['flame'] as String,
            GasFlameLevel.none,
          ),
    group: j['group'] as String?,
    durationSeconds: j['durationSeconds'] as int?,
  );
}

class NutritionSeed {
  NutritionSeed({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
  });

  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? fiber;

  factory NutritionSeed.fromJson(Map<String, dynamic> j) => NutritionSeed(
    calories: (j['calories'] as num?)?.toDouble(),
    protein: (j['protein'] as num?)?.toDouble(),
    carbs: (j['carbs'] as num?)?.toDouble(),
    fat: (j['fat'] as num?)?.toDouble(),
    fiber: (j['fiber'] as num?)?.toDouble(),
  );
}

class RecipeSeed {
  RecipeSeed({
    required this.id,
    required this.name,
    this.description,
    required this.cuisine,
    required this.mealType,
    this.isVegetarian = true,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.nutrition,
    required this.ingredients,
    required this.equipment,
    required this.steps,
  });

  final String id;
  final String name;
  final String? description;
  final CuisineRegion cuisine;
  final MealType mealType;
  final bool isVegetarian;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final NutritionSeed? nutrition;
  final List<RecipeIngredientSeed> ingredients;
  final List<RecipeEquipmentSeed> equipment;
  final List<RecipeStepSeed> steps;

  factory RecipeSeed.fromJson(Map<String, dynamic> j) => RecipeSeed(
    id: j['id'] as String,
    name: j['name'] as String,
    description: j['description'] as String?,
    cuisine: _enumByName(
      CuisineRegion.values,
      j['cuisine'] as String? ?? 'other',
      CuisineRegion.other,
    ),
    mealType: _enumByName(
      MealType.values,
      j['mealType'] as String? ?? 'lunch',
      MealType.lunch,
    ),
    isVegetarian: j['isVegetarian'] as bool? ?? true,
    prepTimeMinutes: j['prepTimeMinutes'] as int?,
    cookTimeMinutes: j['cookTimeMinutes'] as int?,
    nutrition: j['nutrition'] == null
        ? null
        : NutritionSeed.fromJson(j['nutrition'] as Map<String, dynamic>),
    ingredients: (j['ingredients'] as List)
        .map((e) => RecipeIngredientSeed.fromJson(e as Map<String, dynamic>))
        .toList(),
    equipment: (j['equipment'] as List? ?? [])
        .map((e) => RecipeEquipmentSeed.fromJson(e as Map<String, dynamic>))
        .toList(),
    steps: (j['steps'] as List)
        .map((e) => RecipeStepSeed.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// One entry in a substitution map value list.
class SubstitutionSeed {
  SubstitutionSeed({required this.id, this.quality = 1.0, this.note});

  final String id;
  final double quality;
  final String? note;

  factory SubstitutionSeed.fromJson(Map<String, dynamic> j) => SubstitutionSeed(
    id: j['id'] as String,
    quality: (j['quality'] as num?)?.toDouble() ?? 1.0,
    note: j['note'] as String?,
  );
}
