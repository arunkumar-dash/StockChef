import '../../../../core/database/app_database.dart';

/// A recipe ingredient row joined with its canonical ingredient (for the name
/// and default unit). [ingredient] is null only if the dataset references an
/// id missing from the dictionary (guarded against by the validation script).
class RecipeIngredientView {
  const RecipeIngredientView({required this.line, this.ingredient});
  final RecipeIngredient line;
  final Ingredient? ingredient;

  String get displayName => ingredient?.name ?? line.ingredientId;
}

/// A recipe equipment row joined with its equipment and any substitute
/// alternatives (used for the footnote).
class RecipeEquipmentView {
  const RecipeEquipmentView({
    required this.line,
    this.equipment,
    this.substitutes = const [],
  });
  final RecipeEquipment line;
  final EquipmentData? equipment;
  final List<EquipmentAlternative> substitutes;

  String get displayName => equipment?.name ?? line.equipmentId;
}

/// One alternative for a piece of equipment.
class EquipmentAlternative {
  const EquipmentAlternative({required this.name, this.note});
  final String name;
  final String? note;
}

/// A fully-loaded recipe with all children, ready to render on the detail page.
class RecipeDetail {
  const RecipeDetail({
    required this.recipe,
    required this.ingredients,
    required this.steps,
    required this.equipment,
  });

  final Recipe recipe;
  final List<RecipeIngredientView> ingredients;
  final List<RecipeStep> steps;
  final List<RecipeEquipmentView> equipment;

  /// Steps grouped for display: sequential steps map to a single-element group,
  /// while steps sharing a [RecipeStep.stepGroupId] are grouped together so the
  /// UI can show "do these in parallel". Preserves overall order by first
  /// appearance.
  List<List<RecipeStep>> get groupedSteps {
    final ordered = [...steps]..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final result = <List<RecipeStep>>[];
    final groupIndex = <String, int>{};
    for (final step in ordered) {
      final gid = step.stepGroupId;
      if (gid == null) {
        result.add([step]);
      } else if (groupIndex.containsKey(gid)) {
        result[groupIndex[gid]!].add(step);
      } else {
        groupIndex[gid] = result.length;
        result.add([step]);
      }
    }
    return result;
  }
}
