import '../../../core/database/app_database.dart';
import 'match_models.dart';

/// A substitution option: an alternative ingredient id and how good it is.
class SubOption {
  const SubOption(this.id, this.quality);
  final String id;
  final double quality;
}

/// All data the matcher needs, pre-loaded from the database. Keeping this a
/// plain value object lets the ranking algorithm be pure and unit-tested
/// without a database.
class MatchingInput {
  const MatchingInput({
    required this.recipes,
    required this.recipeIngredients,
    required this.ingredientNames,
    required this.ownedExpiry,
    required this.substitutions,
  });

  final List<Recipe> recipes;

  /// recipeId -> its required ingredients.
  final Map<String, List<RecipeIngredient>> recipeIngredients;

  /// ingredientId -> display name.
  final Map<String, String> ingredientNames;

  /// ingredientId -> earliest expiry among owned batches. Presence of the key
  /// means the user owns the ingredient; value may be null if no expiry set.
  final Map<String, DateTime?> ownedExpiry;

  /// ingredientId -> substitution options (owned or not).
  final Map<String, List<SubOption>> substitutions;
}

/// Ranks recipes against current inventory, prioritizing soon-to-expire items
/// and accounting for ingredient substitutions. See PLAN.md Algorithm 1.
///
/// Presence-based (owns-it-or-a-substitute), not quantity-contended — so it is
/// O(recipes × ingredients-per-recipe × subs-per-ingredient) hash lookups, not
/// graph matching.
class RecipeMatcher {
  const RecipeMatcher();

  List<RecipeMatchResult> rank(
    MatchingInput input, {
    MatchingOptions options = const MatchingOptions(),
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final results = input.recipes
        .map((r) => _evaluate(r, input, options, today))
        .toList();

    // Sort within each tier by score (desc); tiers ordered by enum index.
    results.sort((a, b) {
      final tierCmp = a.tier.index.compareTo(b.tier.index);
      if (tierCmp != 0) return tierCmp;
      return b.score.compareTo(a.score);
    });
    return results;
  }

  RecipeMatchResult _evaluate(
    Recipe recipe,
    MatchingInput input,
    MatchingOptions options,
    DateTime today,
  ) {
    final required = (input.recipeIngredients[recipe.id] ?? [])
        .where((ri) => !ri.isOptional)
        .toList();

    var matched = 0;
    final substituted = <SubstitutedIngredient>[];
    final missing = <MissingIngredient>[];
    var expiryUrgency = 0.0;
    var substitutionPenalty = 0.0;
    final expiringNames = <String>[];

    String nameOf(String id) => input.ingredientNames[id] ?? id;

    for (final ri in required) {
      final id = ri.ingredientId;
      if (input.ownedExpiry.containsKey(id)) {
        matched++;
        final expiry = input.ownedExpiry[id];
        if (expiry != null) {
          final daysLeft = _dateOnly(expiry).difference(today).inDays;
          if (daysLeft >= 0 && daysLeft <= options.expiryLookaheadDays) {
            expiryUrgency += 1.0 / (daysLeft + 1);
            expiringNames.add(nameOf(id));
          }
        }
        continue;
      }

      // Not owned directly — try substitutes the user owns.
      if (options.allowSubstitutions) {
        final subs = input.substitutions[id] ?? const [];
        SubOption? best;
        for (final s in subs) {
          if (input.ownedExpiry.containsKey(s.id)) {
            if (best == null || s.quality > best.quality) best = s;
          }
        }
        if (best != null) {
          matched++;
          substituted.add(SubstitutedIngredient(
            requiredId: id,
            requiredName: nameOf(id),
            usedId: best.id,
            usedName: nameOf(best.id),
            quality: best.quality,
          ));
          substitutionPenalty += (1.0 - best.quality);
          continue;
        }
        // Nothing owned — record which substitutes *would* have worked.
        missing.add(MissingIngredient(
          ingredientId: id,
          name: nameOf(id),
          suggestedSubstituteNames: subs.map((s) => nameOf(s.id)).toList(),
        ));
      } else {
        missing.add(MissingIngredient(ingredientId: id, name: nameOf(id)));
      }
    }

    final total = required.length;
    final completeness = total == 0 ? 0.0 : matched / total;
    final subPenaltyNorm = total == 0 ? 0.0 : substitutionPenalty / total;
    // Normalize urgency with a soft cap so it can't dwarf completeness.
    final urgencyNorm = (expiryUrgency / (expiryUrgency + 1)).clamp(0.0, 1.0);

    final score = options.completenessWeight * completeness +
        options.expiryWeight * urgencyNorm -
        options.substitutionPenaltyWeight * subPenaltyNorm;

    final tier = _tier(missing.length, substituted.length, options);

    return RecipeMatchResult(
      recipe: recipe,
      tier: tier,
      score: score,
      matchedCount: matched,
      totalRequired: total,
      substituted: substituted,
      missing: missing,
      usesExpiringItems: expiringNames.isNotEmpty,
      expiringItemNames: expiringNames,
    );
  }

  MatchTier _tier(int missing, int subs, MatchingOptions options) {
    if (missing > 0) return MatchTier.partial;
    if (subs == 0) return MatchTier.makeableNow;
    if (subs <= options.maxSubsForTier2) {
      return MatchTier.makeableWithSubstitution;
    }
    return MatchTier.makeableWithManySubs;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
