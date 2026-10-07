/// Pure decision logic for whether an ingredient needs restocking.
///
/// Per IMPLEMENTATION.md gap A1, the threshold is evaluated on the AGGREGATE
/// quantity on hand for an ingredient against its par level (reorder point),
/// not "% of the last purchase" — which is meaningless with per-batch rows.
///
/// A hysteresis margin prevents the item from flapping on/off the restock list
/// when the quantity hovers right at the threshold.
class RestockThresholdEvaluator {
  const RestockThresholdEvaluator({this.hysteresisPercent = 5});

  /// Extra headroom (in percentage points of par) required to *clear* a
  /// restock flag once set, so small top-ups don't cause churn.
  final double hysteresisPercent;

  /// Decides the restock state for one ingredient.
  ///
  /// [onHand] is the summed quantity across all non-expired batches.
  /// [parQuantity] is the desired full-stock level (> 0).
  /// [thresholdPercent] is the low-stock trigger (e.g. 10 => 10% of par).
  /// [currentlyListed] is whether the item is already on the restock list.
  RestockDecision evaluate({
    required double onHand,
    required double parQuantity,
    required double thresholdPercent,
    required bool currentlyListed,
  }) {
    // Guard against bad/zero par: fall back to "needs restock only if empty".
    if (parQuantity <= 0) {
      final needed = onHand <= 0;
      return RestockDecision(
        shouldBeListed: needed,
        percentOfPar: onHand <= 0 ? 0 : 100,
      );
    }

    final percent = (onHand / parQuantity) * 100;
    final lowerBand = thresholdPercent;
    final upperBand = thresholdPercent + hysteresisPercent;

    final bool shouldBeListed;
    if (currentlyListed) {
      // Stay listed until we climb clear of the hysteresis band.
      shouldBeListed = percent <= upperBand;
    } else {
      // Add to the list once we drop to/below the threshold.
      shouldBeListed = percent <= lowerBand;
    }

    return RestockDecision(shouldBeListed: shouldBeListed, percentOfPar: percent);
  }
}

/// Outcome of a restock evaluation.
class RestockDecision {
  const RestockDecision({required this.shouldBeListed, required this.percentOfPar});

  /// Whether the ingredient should appear on the restock list.
  final bool shouldBeListed;

  /// Current stock as a percentage of par (for display / suggested quantity).
  final double percentOfPar;
}
