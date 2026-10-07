import 'package:flutter/material.dart';

import '../../../core/database/enums.dart';

/// Human-readable labels and icons for recipe-related enums, kept in one place
/// so list, detail and (later) add/edit screens render them consistently.

extension CuisineLabel on CuisineRegion {
  String get label => switch (this) {
    CuisineRegion.tamil => 'Tamil',
    CuisineRegion.odia => 'Odia',
    CuisineRegion.punjabi => 'Punjabi',
    CuisineRegion.bengali => 'Bengali',
    CuisineRegion.gujarati => 'Gujarati',
    CuisineRegion.keralite => 'Keralite',
    CuisineRegion.andhra => 'Andhra',
    CuisineRegion.maharashtrian => 'Maharashtrian',
    CuisineRegion.other => 'Other',
  };
}

extension MealTypeLabel on MealType {
  String get label => switch (this) {
    MealType.breakfast => 'Breakfast',
    MealType.lunch => 'Lunch',
    MealType.dinner => 'Dinner',
    MealType.snack => 'Snack',
    MealType.dessert => 'Dessert',
    MealType.beverage => 'Beverage',
  };
}

extension GasFlameLevelDisplay on GasFlameLevel {
  String get label => switch (this) {
    GasFlameLevel.high => 'High flame',
    GasFlameLevel.medium => 'Medium flame',
    GasFlameLevel.low => 'Low flame',
    GasFlameLevel.none => 'No heat',
  };

  IconData get icon => switch (this) {
    GasFlameLevel.high => Icons.local_fire_department,
    GasFlameLevel.medium => Icons.local_fire_department_outlined,
    GasFlameLevel.low => Icons.whatshot_outlined,
    GasFlameLevel.none => Icons.ac_unit,
  };

  /// Relative intensity color: hotter flame → warmer color.
  Color color(ColorScheme scheme) => switch (this) {
    GasFlameLevel.high => const Color(0xFFD84315),
    GasFlameLevel.medium => const Color(0xFFEF6C00),
    GasFlameLevel.low => const Color(0xFFF9A825),
    GasFlameLevel.none => scheme.onSurfaceVariant,
  };
}
