import 'package:drift/drift.dart';

import '../enums.dart';

/// Canonical ingredient dictionary (seeded from `assets/data/ingredients.json`).
/// One row per distinct cooking ingredient; recipes and inventory reference
/// these by [id].
class Ingredients extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// Loose grouping (e.g. "spice", "vegetable", "dal") — informational.
  TextColumn get category => text().nullable()();

  /// The unit this ingredient is normally measured in.
  TextColumn get defaultUnit => textEnum<MeasurementUnit>()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Canonical equipment dictionary (seeded from `assets/data/equipment.json`).
class Equipment extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Directed ingredient substitution edges: [alternativeIngredientId] may stand
/// in for [ingredientId]. [qualityRatio] (0..1) captures how good a swap it is
/// (1.0 = perfect); the matcher prefers higher ratios and penalizes low ones.
class IngredientSubstitutions extends Table {
  TextColumn get id => text()();
  TextColumn get ingredientId => text()();
  TextColumn get alternativeIngredientId => text()();
  RealColumn get qualityRatio => real().withDefault(const Constant(1.0))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Directed equipment substitution edges: [alternativeEquipmentId] may stand in
/// for [equipmentId]. Shown as an informational footnote on recipes.
class EquipmentSubstitutions extends Table {
  TextColumn get id => text()();
  TextColumn get equipmentId => text()();
  TextColumn get alternativeEquipmentId => text()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Per-ingredient stock policy used by the restock engine (gap A1): the
/// restock threshold is evaluated against a *par level* (desired stock), not
/// "% of last purchase". Seeded with sensible defaults for core staples and
/// user-editable.
class IngredientStockPolicies extends Table {
  TextColumn get ingredientId => text()();

  /// Desired "full" stock level; restock triggers below
  /// [thresholdPercent]% of this.
  RealColumn get parQuantity => real()();
  TextColumn get unit => textEnum<MeasurementUnit>()();
  RealColumn get thresholdPercent => real().withDefault(const Constant(10))();

  /// Core staples get proactive low-stock reminders.
  BoolColumn get isCore => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {ingredientId};
}
