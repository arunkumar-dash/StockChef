import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/recipes/domain/services/portion_scaler.dart';

void main() {
  const scaler = PortionScaler();

  test('linear units scale and round to sensible increments', () {
    // 40g per serving * 3 = 120g (rounded to nearest 5g).
    final r = scaler.scale(
      quantityPerServing: 40,
      unit: MeasurementUnit.grams,
      servings: 3,
    );
    expect(r.value, 120);
    expect(r.isToTaste, isFalse);

    // 0.5 tsp * 3 = 1.5, rounds to nearest 0.25.
    final tsp = scaler.scale(
      quantityPerServing: 0.5,
      unit: MeasurementUnit.teaspoons,
      servings: 3,
    );
    expect(tsp.value, 1.5);
  });

  test('discrete counts round to whole numbers and never zero out', () {
    // 0.5 onion * 2 = 1 whole piece.
    expect(
      scaler
          .scale(quantityPerServing: 0.5, unit: MeasurementUnit.pieces, servings: 2)
          .value,
      1,
    );
    // 0.5 * 1 = 0.5 -> rounds to 1 (never drop a required item to zero).
    expect(
      scaler
          .scale(quantityPerServing: 0.5, unit: MeasurementUnit.pieces, servings: 1)
          .value,
      1,
    );
    // 1 egg * 4 = 4 whole eggs, not 4.0-ish.
    expect(
      scaler
          .scale(quantityPerServing: 1, unit: MeasurementUnit.pieces, servings: 4)
          .value,
      4,
    );
  });

  test('to-taste is never scaled', () {
    final r = scaler.scale(
      quantityPerServing: 1,
      unit: MeasurementUnit.toTaste,
      servings: 8,
    );
    expect(r.isToTaste, isTrue);
    expect(formatScaledQuantity(r), 'to taste');
  });

  test('pinch scales sub-linearly in blocks, not literally', () {
    // 1 pinch covers up to 4 servings -> still 1 pinch at 4 servings.
    expect(
      scaler
          .scale(quantityPerServing: 1, unit: MeasurementUnit.pinch, servings: 4)
          .value,
      1,
    );
    // 5 servings -> ceil(5/4) = 2 pinches.
    expect(
      scaler
          .scale(quantityPerServing: 1, unit: MeasurementUnit.pinch, servings: 5)
          .value,
      2,
    );
  });

  test('servings below 1 are clamped to 1', () {
    final r = scaler.scale(
      quantityPerServing: 10,
      unit: MeasurementUnit.grams,
      servings: 0,
    );
    expect(r.value, 10);
  });

  test('formats quantities without trailing .0', () {
    final r = scaler.scale(
      quantityPerServing: 50,
      unit: MeasurementUnit.grams,
      servings: 2,
    );
    expect(formatScaledQuantity(r), '100 g');
  });
}
