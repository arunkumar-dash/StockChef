import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/core/database/enums.dart';
import 'package:stockchef/features/ocr_scan/domain/bill_line_parser.dart';

void main() {
  final candidates = [
    const IngredientCandidate(
      id: 'tomato',
      name: 'Tomato',
      aliases: ['thakkali', 'tamatar'],
      defaultUnit: MeasurementUnit.pieces,
    ),
    const IngredientCandidate(
      id: 'toor_dal',
      name: 'Toor Dal',
      aliases: ['arhar', 'tuvar dal'],
      defaultUnit: MeasurementUnit.grams,
    ),
    const IngredientCandidate(
      id: 'cooking_oil',
      name: 'Cooking Oil',
      aliases: ['oil'],
      defaultUnit: MeasurementUnit.milliliters,
    ),
  ];
  final parser = BillLineParser(candidates);

  test('exact name match is high confidence and picks default unit', () {
    final e = parser.parseLine('Toor Dal, 500, g')!;
    expect(e.matchedIngredientId, 'toor_dal');
    expect(e.confidence, 1.0);
    expect(e.quantity, 500);
    expect(e.unit, MeasurementUnit.grams);
    expect(e.needsReview, isFalse);
  });

  test('fuzzy match tolerates OCR noise (TOMATOE -> tomato)', () {
    final e = parser.parseLine('TOMATOE, 2, kg')!;
    expect(e.matchedIngredientId, 'tomato');
    expect(e.quantity, 2);
    expect(e.unit, MeasurementUnit.kilograms);
  });

  test('alias match works (arhar -> toor_dal)', () {
    final e = parser.parseLine('Arhar 1kg')!;
    expect(e.matchedIngredientId, 'toor_dal');
  });

  test('unknown item stays unmatched and needs review', () {
    final e = parser.parseLine('Dishwash Bar, 1, pc')!;
    expect(e.matchedIngredientId, isNull);
    expect(e.needsReview, isTrue);
    expect(e.nameGuess, 'Dishwash Bar');
  });

  test('empty line yields null', () {
    expect(parser.parseLine('   '), isNull);
  });

  test('parses a multi-line bill', () {
    const bill = 'Tomato, 2, kg\nToor Dal, 500, g\n\nOil, 1, l';
    final entries = parser.parse(bill);
    expect(entries, hasLength(3));
    expect(entries.map((e) => e.matchedIngredientId),
        containsAll(['tomato', 'toor_dal', 'cooking_oil']));
  });
}
