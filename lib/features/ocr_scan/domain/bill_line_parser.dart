import '../../../core/database/enums.dart';

/// A candidate ingredient the parser can fuzzy-match OCR text against.
class IngredientCandidate {
  const IngredientCandidate({
    required this.id,
    required this.name,
    this.aliases = const [],
    required this.defaultUnit,
  });
  final String id;
  final String name;
  final List<String> aliases;
  final MeasurementUnit defaultUnit;
}

/// A draft line produced from a scanned bill, ready for user review/edit.
class DraftEntry {
  DraftEntry({
    required this.rawText,
    required this.nameGuess,
    this.quantity,
    this.unit,
    this.matchedIngredientId,
    this.confidence = 0,
  });

  final String rawText;
  String nameGuess;
  double? quantity;
  MeasurementUnit? unit;
  String? matchedIngredientId;
  double confidence;

  /// <0.5 = user must confirm; 0.5–0.75 = pre-selected but flagged; >=0.75 auto.
  bool get needsReview => confidence < 0.75;
}

/// Parses grocery-bill text into draft entries (PLAN.md Algorithm 7).
///
/// The user inserts commas to delimit columns, so column splitting is exact and
/// we don't attempt fragile auto-detection. Item names are fuzzy-matched to the
/// ingredient dictionary via token overlap + normalized edit distance.
class BillLineParser {
  BillLineParser(this._candidates) {
    _aliasIndex = {};
    for (final c in _candidates) {
      _aliasIndex[_normalize(c.name)] = c;
      for (final a in c.aliases) {
        _aliasIndex[_normalize(a)] = c;
      }
    }
  }

  final List<IngredientCandidate> _candidates;
  late final Map<String, IngredientCandidate> _aliasIndex;

  static final _qtyUnit = RegExp(r'(\d+\.?\d*)\s*([a-zA-Z]+)?');
  static const _unitAliases = {
    'kg': MeasurementUnit.kilograms,
    'kgs': MeasurementUnit.kilograms,
    'g': MeasurementUnit.grams,
    'gm': MeasurementUnit.grams,
    'gms': MeasurementUnit.grams,
    'grams': MeasurementUnit.grams,
    'l': MeasurementUnit.liters,
    'ltr': MeasurementUnit.liters,
    'ml': MeasurementUnit.milliliters,
    'pc': MeasurementUnit.pieces,
    'pcs': MeasurementUnit.pieces,
    'nos': MeasurementUnit.pieces,
    'no': MeasurementUnit.pieces,
  };

  /// Parses one comma-delimited line into a draft entry, or null if empty.
  DraftEntry? parseLine(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return null;

    final columns = trimmed.split(',').map((c) => c.trim()).toList();
    double? qty;
    MeasurementUnit? unit;
    final nameParts = <String>[];

    for (final col in columns) {
      final lower = col.toLowerCase();
      // A column that is purely a unit token ("kg", "pcs").
      if (_unitAliases.containsKey(lower)) {
        unit ??= _unitAliases[lower];
        continue;
      }
      // A column that starts with a number: quantity (+ maybe an attached unit).
      final m = _qtyUnit.firstMatch(col);
      if (m != null && RegExp(r'^\s*\d').hasMatch(col)) {
        qty ??= double.tryParse(m.group(1)!);
        final u = m.group(2)?.toLowerCase();
        if (u != null && _unitAliases.containsKey(u)) unit ??= _unitAliases[u];
        continue;
      }
      // Otherwise treat as part of the item name.
      nameParts.add(col);
    }

    final nameCol = nameParts.isNotEmpty ? nameParts.join(' ') : columns.first;

    final entry = DraftEntry(rawText: trimmed, nameGuess: nameCol, quantity: qty, unit: unit);
    final match = matchIngredient(nameCol);
    if (match != null) {
      entry.matchedIngredientId = match.$1.id;
      entry.confidence = match.$2;
      entry.unit ??= match.$1.defaultUnit;
      if (match.$2 >= 0.75) entry.nameGuess = match.$1.name;
    }
    return entry;
  }

  List<DraftEntry> parse(String text) {
    return text
        .split('\n')
        .map(parseLine)
        .whereType<DraftEntry>()
        .toList();
  }

  /// Returns the best matching candidate and a confidence 0..1, or null.
  (IngredientCandidate, double)? matchIngredient(String raw) {
    final norm = _normalize(raw);
    if (norm.isEmpty) return null;

    // Exact alias/name hit.
    final exact = _aliasIndex[norm];
    if (exact != null) return (exact, 1.0);

    IngredientCandidate? best;
    var bestScore = 0.0;
    for (final c in _candidates) {
      final targets = [c.name, ...c.aliases].map(_normalize);
      for (final t in targets) {
        final score = _similarity(norm, t);
        if (score > bestScore) {
          bestScore = score;
          best = c;
        }
      }
    }
    if (best == null || bestScore < 0.4) return null;
    return (best, bestScore);
  }

  /// Combined token-overlap + normalized edit-distance similarity.
  double _similarity(String a, String b) {
    final tokenScore = _jaccardTokens(a, b);
    final editScore = 1 - _levenshtein(a, b) / (a.length > b.length ? a.length : b.length);
    return 0.5 * tokenScore + 0.5 * editScore;
  }

  double _jaccardTokens(String a, String b) {
    final sa = a.split(' ').toSet();
    final sb = b.split(' ').toSet();
    if (sa.isEmpty || sb.isEmpty) return 0;
    final inter = sa.intersection(sb).length;
    final union = sa.union(sb).length;
    return inter / union;
  }

  static String _normalize(String s) {
    var out = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), ' ').trim();
    out = out.replaceAll(RegExp(r'\s+'), ' ');
    // Strip a trailing plural 's' on each token to improve matching.
    out = out
        .split(' ')
        .map((t) => t.length > 3 && t.endsWith('s') ? t.substring(0, t.length - 1) : t)
        .join(' ');
    return out;
  }

  static int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    final prev = List<int>.generate(b.length + 1, (i) => i);
    final curr = List<int>.filled(b.length + 1, 0);
    for (var i = 0; i < a.length; i++) {
      curr[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        curr[j + 1] = [curr[j] + 1, prev[j + 1] + 1, prev[j] + cost].reduce((x, y) => x < y ? x : y);
      }
      for (var j = 0; j <= b.length; j++) {
        prev[j] = curr[j];
      }
    }
    return prev[b.length];
  }
}
