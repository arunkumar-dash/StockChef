// Validates the bundled JSON dataset for internal consistency.
//
// Run from the project root:  dart run tool/validate_dataset.dart
//
// Exits non-zero (and prints every problem) if any recipe references an unknown
// ingredient/equipment id, a substitution points at an unknown id, required
// fields are missing, or ids are duplicated. Also prints the cuisine
// distribution so we can track the ~60 Tamil / ~60 Odia / ~30 other target.

import 'dart:convert';
import 'dart:io';

const _validUnits = {
  'grams', 'kilograms', 'milliliters', 'liters', 'pieces',
  'teaspoons', 'tablespoons', 'cups', 'pinch', 'toTaste',
};
const _validFlames = {'high', 'medium', 'low', 'none'};
const _validCuisines = {
  'tamil', 'odia', 'punjabi', 'bengali', 'gujarati',
  'keralite', 'andhra', 'maharashtrian', 'other',
};
const _validMealTypes = {
  'breakfast', 'lunch', 'dinner', 'snack', 'dessert', 'beverage',
};

final _errors = <String>[];
final _warnings = <String>[];

void _err(String m) => _errors.add(m);
void _warn(String m) => _warnings.add(m);

Map<String, dynamic> _readJson(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    _err('Missing asset: $path');
    return {};
  }
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    return decoded is Map<String, dynamic> ? decoded : {'_root': decoded};
  } catch (e) {
    _err('Invalid JSON in $path: $e');
    return {};
  }
}

void main() {
  const base = 'assets/data';
  final ingredientsJson = _readJson('$base/ingredients.json');
  final equipmentJson = _readJson('$base/equipment.json');
  final recipesJson = _readJson('$base/recipes.json');
  final ingSubsJson = _readJson('$base/ingredient_substitutions.json');
  final eqSubsJson = _readJson('$base/equipment_substitutions.json');

  // --- dictionaries ---
  final ingredientIds = <String>{};
  for (final raw in (ingredientsJson['ingredients'] as List? ?? [])) {
    final m = raw as Map<String, dynamic>;
    final id = m['id'] as String?;
    if (id == null) {
      _err('Ingredient with no id: $m');
      continue;
    }
    if (!ingredientIds.add(id)) _err('Duplicate ingredient id: $id');
    final unit = m['defaultUnit'] as String?;
    if (unit != null && !_validUnits.contains(unit)) {
      _err('Ingredient $id has invalid defaultUnit "$unit"');
    }
  }

  final equipmentIds = <String>{};
  for (final raw in (equipmentJson['equipment'] as List? ?? [])) {
    final m = raw as Map<String, dynamic>;
    final id = m['id'] as String?;
    if (id == null) {
      _err('Equipment with no id: $m');
      continue;
    }
    if (!equipmentIds.add(id)) _err('Duplicate equipment id: $id');
  }

  // --- recipes ---
  final recipeIds = <String>{};
  final cuisineCounts = <String, int>{};
  for (final raw in (recipesJson['recipes'] as List? ?? [])) {
    final m = raw as Map<String, dynamic>;
    final id = m['id'] as String? ?? '(no id)';
    if (id == '(no id)') _err('Recipe with no id: ${m['name']}');
    if (!recipeIds.add(id)) _err('Duplicate recipe id: $id');

    final cuisine = m['cuisine'] as String?;
    if (cuisine == null || !_validCuisines.contains(cuisine)) {
      _err('Recipe $id has invalid cuisine "$cuisine"');
    } else {
      cuisineCounts[cuisine] = (cuisineCounts[cuisine] ?? 0) + 1;
    }
    final meal = m['mealType'] as String?;
    if (meal != null && !_validMealTypes.contains(meal)) {
      _err('Recipe $id has invalid mealType "$meal"');
    }

    final ingredients = m['ingredients'] as List? ?? [];
    if (ingredients.isEmpty) _err('Recipe $id has no ingredients');
    for (final ri in ingredients) {
      final rim = ri as Map<String, dynamic>;
      final iid = rim['ingredientId'] as String?;
      if (iid == null) {
        _err('Recipe $id has an ingredient with no ingredientId');
      } else if (!ingredientIds.contains(iid)) {
        _err('Recipe $id references unknown ingredient "$iid"');
      }
      if (rim['quantity'] == null) {
        _err('Recipe $id ingredient "$iid" missing quantity');
      }
      final unit = rim['unit'] as String?;
      if (unit != null && !_validUnits.contains(unit)) {
        _err('Recipe $id ingredient "$iid" has invalid unit "$unit"');
      }
    }

    for (final re in (m['equipment'] as List? ?? [])) {
      final eid = (re as Map<String, dynamic>)['equipmentId'] as String?;
      if (eid != null && !equipmentIds.contains(eid)) {
        _err('Recipe $id references unknown equipment "$eid"');
      }
    }

    final steps = m['steps'] as List? ?? [];
    if (steps.isEmpty) _err('Recipe $id has no steps');
    var sawFlame = false;
    for (final st in steps) {
      final sm = st as Map<String, dynamic>;
      if (sm['instruction'] == null) _err('Recipe $id has a step with no instruction');
      if (sm['order'] == null) _err('Recipe $id has a step with no order');
      final flame = sm['flame'] as String?;
      if (flame != null) {
        if (!_validFlames.contains(flame)) {
          _err('Recipe $id step has invalid flame "$flame"');
        }
        if (flame != 'none') sawFlame = true;
      }
    }
    if (!sawFlame) {
      _warn('Recipe $id has no on-stove (flame) step — verify this is intended');
    }
  }

  // --- substitutions ---
  void checkSubs(String label, Map<String, dynamic> json, Set<String> validIds) {
    final subs = json['substitutions'] as Map<String, dynamic>? ?? {};
    subs.forEach((key, value) {
      if (!validIds.contains(key)) _err('$label substitution key "$key" is unknown');
      for (final alt in (value as List)) {
        final altId = (alt as Map<String, dynamic>)['id'] as String?;
        if (altId == null) {
          _err('$label substitution for "$key" has an entry with no id');
        } else if (!validIds.contains(altId)) {
          _err('$label substitution for "$key" points at unknown id "$altId"');
        }
      }
    });
  }

  checkSubs('Ingredient', ingSubsJson, ingredientIds);
  checkSubs('Equipment', eqSubsJson, equipmentIds);

  // --- report ---
  stdout.writeln('Dataset validation report');
  stdout.writeln('  ingredients: ${ingredientIds.length}');
  stdout.writeln('  equipment:   ${equipmentIds.length}');
  stdout.writeln('  recipes:     ${recipeIds.length}');
  stdout.writeln('  cuisine distribution: $cuisineCounts');
  final tamil = cuisineCounts['tamil'] ?? 0;
  final odia = cuisineCounts['odia'] ?? 0;
  if (recipeIds.isNotEmpty && (tamil < 40 || odia < 40)) {
    _warn('Tamil ($tamil) or Odia ($odia) count is below the ~60 target');
  }

  if (_warnings.isNotEmpty) {
    stdout.writeln('\n${_warnings.length} warning(s):');
    for (final w in _warnings) {
      stdout.writeln('  ⚠ $w');
    }
  }

  if (_errors.isNotEmpty) {
    stderr.writeln('\n${_errors.length} error(s):');
    for (final e in _errors) {
      stderr.writeln('  ✗ $e');
    }
    exitCode = 1;
  } else {
    stdout.writeln('\n✓ No errors.');
  }
}
