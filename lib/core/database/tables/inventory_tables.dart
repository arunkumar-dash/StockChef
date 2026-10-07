import 'package:drift/drift.dart';

import '../enums.dart';

/// One purchase BATCH of an ingredient. Kept per-batch (not aggregated) so
/// batches with different expiry dates surface individually for FIFO/expiry
/// reminders. Restock checks aggregate across batches (see RestockThreshold).
class InventoryItems extends Table {
  TextColumn get id => text()();

  /// Which kitchen this batch belongs to (defaults to the permanent "home").
  TextColumn get kitchenId =>
      text().withDefault(const Constant('home'))();

  /// Links to the canonical ingredient. Null for a free-text item the user
  /// typed that isn't in the dictionary (still tracked, just unmatched).
  TextColumn get ingredientId => text().nullable()();
  TextColumn get customName => text().nullable()();

  RealColumn get quantity => real()();
  TextColumn get unit => textEnum<MeasurementUnit>()();

  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get shelfLifeDays => integer().nullable()();
  DateTimeColumn get expiryDate => dateTime()();

  /// How much this batch started at — informational only (restock uses par
  /// levels, not this).
  RealColumn get originalQuantity => real().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The restock shopping list. Rows are auto-generated when aggregate stock for
/// an ingredient drops below its par threshold, or added manually / via OCR.
class RestockListItems extends Table {
  TextColumn get id => text()();

  /// Which kitchen this restock entry belongs to.
  TextColumn get kitchenId =>
      text().withDefault(const Constant('home'))();

  TextColumn get ingredientId => text().nullable()();
  TextColumn get itemName => text()();
  RealColumn get suggestedQuantity => real().nullable()();
  TextColumn get unit => textEnum<MeasurementUnit>().nullable()();
  TextColumn get reason => textEnum<RestockReason>()();
  DateTimeColumn get addedAt => dateTime()();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// A logged cooking event. Feeds the "idle ingredient" check: an ingredient is
/// idle if it hasn't appeared in a cook event within the idle window.
/// [ingredientIdsCsv] denormalizes the consumed ingredient ids to avoid a
/// 3-table join on every idle computation.
class CookEvents extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text().nullable()();
  DateTimeColumn get cookedAt => dateTime()();
  TextColumn get ingredientIdsCsv => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
