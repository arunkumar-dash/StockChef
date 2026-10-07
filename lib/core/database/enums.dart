// Domain enums persisted by Drift (stored as their `name` via `textEnum`).
//
// Keep enum *value order* stable and only append new values — `textEnum`
// stores the enum's `name` string, so renaming a value would orphan existing
// rows. Adding new values at the end is always safe.

/// Stove/gas flame intensity called out in a cooking step. `none` = an
/// off-stove step (chopping, resting, plating).
enum GasFlameLevel { high, medium, low, none }

/// Units used for both recipe quantities and inventory amounts.
/// `toTaste` and `pinch` are intentionally non-linear when scaling portions
/// (see PortionScaler in Phase 3).
enum MeasurementUnit {
  grams,
  kilograms,
  milliliters,
  liters,
  pieces,
  teaspoons,
  tablespoons,
  cups,
  pinch,
  toTaste,
}

/// Regional cuisine of a recipe. Tamil & Odia are the mandatory majority;
/// `other` covers the remaining pan-Indian regional recipes.
enum CuisineRegion {
  tamil,
  odia,
  punjabi,
  bengali,
  gujarati,
  keralite,
  andhra,
  maharashtrian,
  other,
}

enum MealType { breakfast, lunch, dinner, snack, dessert, beverage }

/// Why an item is on the restock list.
enum RestockReason { lowStock, manual, ocrImport }

/// Kind of scheduled local notification.
enum ReminderType { expiry, lowStockDigest }
