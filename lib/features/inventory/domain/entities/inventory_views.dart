import '../../../../core/database/app_database.dart';

/// Inventory freshness relative to expiry, for badges/sorting.
enum FreshnessStatus { fresh, expiringSoon, expired }

/// A single inventory batch joined with its ingredient (for the display name).
class InventoryBatchView {
  const InventoryBatchView({required this.batch, this.ingredient});
  final InventoryItem batch;
  final Ingredient? ingredient;

  String get displayName =>
      ingredient?.name ?? batch.customName ?? batch.ingredientId ?? 'Unknown';

  int daysUntilExpiry(DateTime now) =>
      DateTime(batch.expiryDate.year, batch.expiryDate.month, batch.expiryDate.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;

  FreshnessStatus freshness(DateTime now, {int soonDays = 3}) {
    final d = daysUntilExpiry(now);
    if (d < 0) return FreshnessStatus.expired;
    if (d <= soonDays) return FreshnessStatus.expiringSoon;
    return FreshnessStatus.fresh;
  }
}

/// All batches of one ingredient rolled up, with the soonest expiry surfaced.
class IngredientStockView {
  const IngredientStockView({
    required this.ingredientId,
    required this.displayName,
    required this.totalQuantity,
    required this.unit,
    required this.batches,
    required this.soonestExpiry,
  });

  final String ingredientId;
  final String displayName;
  final double totalQuantity;
  final String unit;
  final List<InventoryBatchView> batches;
  final DateTime? soonestExpiry;

  FreshnessStatus freshness(DateTime now, {int soonDays = 3}) {
    if (soonestExpiry == null) return FreshnessStatus.fresh;
    final d = DateTime(soonestExpiry!.year, soonestExpiry!.month, soonestExpiry!.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (d < 0) return FreshnessStatus.expired;
    if (d <= soonDays) return FreshnessStatus.expiringSoon;
    return FreshnessStatus.fresh;
  }
}
