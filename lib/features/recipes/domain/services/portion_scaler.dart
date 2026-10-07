import '../../../../core/database/enums.dart';

/// How a given unit behaves when a recipe is scaled to more/fewer servings.
enum ScalingClass {
  /// Never scaled (e.g. "salt to taste").
  fixed,

  /// Whole-number items (eggs, whole chilies): round to an integer, min 1.
  countDiscrete,

  /// Scales in coarse blocks, not linearly (a pinch/dash).
  sublinearDiscrete,

  /// Ordinary continuous scaling (grams, ml, tsp) with sensible rounding.
  linear,
}

/// Static metadata driving how each [MeasurementUnit] scales.
class _UnitMeta {
  const _UnitMeta(this.scalingClass, {this.increment = 1, this.stepServings = 4});
  final ScalingClass scalingClass;

  /// Rounding increment for [ScalingClass.linear] (e.g. 0.25 tsp, 5 g).
  final double increment;

  /// Servings covered by one unit for [ScalingClass.sublinearDiscrete].
  final int stepServings;
}

const Map<MeasurementUnit, _UnitMeta> _unitMeta = {
  MeasurementUnit.grams: _UnitMeta(ScalingClass.linear, increment: 5),
  MeasurementUnit.kilograms: _UnitMeta(ScalingClass.linear, increment: 0.05),
  MeasurementUnit.milliliters: _UnitMeta(ScalingClass.linear, increment: 5),
  MeasurementUnit.liters: _UnitMeta(ScalingClass.linear, increment: 0.05),
  MeasurementUnit.teaspoons: _UnitMeta(ScalingClass.linear, increment: 0.25),
  MeasurementUnit.tablespoons: _UnitMeta(ScalingClass.linear, increment: 0.25),
  MeasurementUnit.cups: _UnitMeta(ScalingClass.linear, increment: 0.25),
  MeasurementUnit.pieces: _UnitMeta(ScalingClass.countDiscrete),
  MeasurementUnit.pinch: _UnitMeta(ScalingClass.sublinearDiscrete, stepServings: 4),
  MeasurementUnit.toTaste: _UnitMeta(ScalingClass.fixed),
};

/// Result of scaling a single ingredient quantity.
class ScaledQuantity {
  const ScaledQuantity({required this.value, required this.unit, required this.isToTaste});
  final double value;
  final MeasurementUnit unit;

  /// True for "to taste" style ingredients that carry no numeric amount.
  final bool isToTaste;
}

/// Scales recipe quantities (authored per single serving) to N servings.
///
/// Recipes are stored per-person, so scaling is `quantityPerServing * servings`
/// followed by unit-appropriate rounding — never a naive multiply that would
/// produce "2.3 eggs" or "8 pinches". See PLAN.md Algorithm 2.
class PortionScaler {
  const PortionScaler();

  ScaledQuantity scale({
    required double quantityPerServing,
    required MeasurementUnit unit,
    required int servings,
  }) {
    final n = servings < 1 ? 1 : servings;
    final meta = _unitMeta[unit] ?? const _UnitMeta(ScalingClass.linear, increment: 1);
    final raw = quantityPerServing * n;

    switch (meta.scalingClass) {
      case ScalingClass.fixed:
        return ScaledQuantity(value: quantityPerServing, unit: unit, isToTaste: true);

      case ScalingClass.countDiscrete:
        var scaled = raw.round();
        if (raw > 0 && scaled == 0) scaled = 1; // never zero out a required item
        return ScaledQuantity(value: scaled.toDouble(), unit: unit, isToTaste: false);

      case ScalingClass.sublinearDiscrete:
        final steps = (n / meta.stepServings).ceil();
        final base = quantityPerServing <= 0 ? 0 : quantityPerServing.ceil();
        return ScaledQuantity(
          value: (base * steps).toDouble(),
          unit: unit,
          isToTaste: false,
        );

      case ScalingClass.linear:
        final scaled = _roundToIncrement(raw, meta.increment);
        return ScaledQuantity(value: scaled, unit: unit, isToTaste: false);
    }
  }

  static double _roundToIncrement(double x, double inc) {
    if (inc <= 0) return x;
    return (x / inc).round() * inc;
  }
}

/// Human-friendly rendering of a [MeasurementUnit].
extension MeasurementUnitLabel on MeasurementUnit {
  String get label => switch (this) {
    MeasurementUnit.grams => 'g',
    MeasurementUnit.kilograms => 'kg',
    MeasurementUnit.milliliters => 'ml',
    MeasurementUnit.liters => 'L',
    MeasurementUnit.pieces => 'pc',
    MeasurementUnit.teaspoons => 'tsp',
    MeasurementUnit.tablespoons => 'tbsp',
    MeasurementUnit.cups => 'cup',
    MeasurementUnit.pinch => 'pinch',
    MeasurementUnit.toTaste => 'to taste',
  };
}

/// Formats a scaled quantity for display, dropping trailing ".0" and handling
/// the to-taste case.
String formatScaledQuantity(ScaledQuantity q) {
  if (q.isToTaste) return q.unit.label;
  final v = q.value;
  final text = v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  return '$text ${q.unit.label}';
}
