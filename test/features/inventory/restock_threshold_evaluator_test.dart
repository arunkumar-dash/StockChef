import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/features/inventory/domain/services/restock_threshold_evaluator.dart';

void main() {
  const evaluator = RestockThresholdEvaluator(hysteresisPercent: 5);

  test('adds to list when at/below threshold', () {
    final d = evaluator.evaluate(
      onHand: 90,
      parQuantity: 1000,
      thresholdPercent: 10,
      currentlyListed: false,
    );
    expect(d.shouldBeListed, isTrue); // 9% <= 10%
    expect(d.percentOfPar, closeTo(9, 0.001));
  });

  test('stays off list when comfortably above threshold', () {
    final d = evaluator.evaluate(
      onHand: 500,
      parQuantity: 1000,
      thresholdPercent: 10,
      currentlyListed: false,
    );
    expect(d.shouldBeListed, isFalse);
  });

  test('hysteresis: stays listed between threshold and threshold+margin', () {
    // 12% is above the 10% add-threshold but within the 15% clear-band.
    final d = evaluator.evaluate(
      onHand: 120,
      parQuantity: 1000,
      thresholdPercent: 10,
      currentlyListed: true,
    );
    expect(d.shouldBeListed, isTrue);
  });

  test('hysteresis: clears once above threshold+margin', () {
    // 16% clears the 15% band.
    final d = evaluator.evaluate(
      onHand: 160,
      parQuantity: 1000,
      thresholdPercent: 10,
      currentlyListed: true,
    );
    expect(d.shouldBeListed, isFalse);
  });

  test('no flapping: 12% does not add when not already listed', () {
    final d = evaluator.evaluate(
      onHand: 120,
      parQuantity: 1000,
      thresholdPercent: 10,
      currentlyListed: false,
    );
    expect(d.shouldBeListed, isFalse);
  });

  test('bad par level falls back to empty-only trigger', () {
    expect(
      evaluator
          .evaluate(onHand: 0, parQuantity: 0, thresholdPercent: 10, currentlyListed: false)
          .shouldBeListed,
      isTrue,
    );
    expect(
      evaluator
          .evaluate(onHand: 5, parQuantity: 0, thresholdPercent: 10, currentlyListed: false)
          .shouldBeListed,
      isFalse,
    );
  });
}
