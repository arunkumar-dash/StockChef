import '../../../core/database/app_database.dart';

/// How readily a recipe can be made from current inventory.
enum MatchTier {
  /// Every required ingredient is owned directly.
  makeableNow,

  /// All ingredients covered, but 1-2 rely on a substitute.
  makeableWithSubstitution,

  /// All ingredients covered, but relying on several substitutes.
  makeableWithManySubs,

  /// One or more required ingredients are missing (and unsubstitutable).
  partial,
}

extension MatchTierLabel on MatchTier {
  String get label => switch (this) {
    MatchTier.makeableNow => 'Make it now',
    MatchTier.makeableWithSubstitution => 'With a substitution',
    MatchTier.makeableWithManySubs => 'With substitutions',
    MatchTier.partial => 'Almost — a few missing',
  };
}

/// A required ingredient that was matched via a substitute the user owns.
class SubstitutedIngredient {
  const SubstitutedIngredient({
    required this.requiredId,
    required this.requiredName,
    required this.usedId,
    required this.usedName,
    required this.quality,
  });
  final String requiredId;
  final String requiredName;
  final String usedId;
  final String usedName;
  final double quality;
}

/// A required ingredient the user has neither directly nor via a substitute.
class MissingIngredient {
  const MissingIngredient({
    required this.ingredientId,
    required this.name,
    this.suggestedSubstituteNames = const [],
  });
  final String ingredientId;
  final String name;

  /// Substitutes that *would* work but the user doesn't own either.
  final List<String> suggestedSubstituteNames;
}

/// The result of evaluating one recipe against the current inventory.
class RecipeMatchResult {
  const RecipeMatchResult({
    required this.recipe,
    required this.tier,
    required this.score,
    required this.matchedCount,
    required this.totalRequired,
    required this.substituted,
    required this.missing,
    required this.usesExpiringItems,
    required this.expiringItemNames,
  });

  final Recipe recipe;
  final MatchTier tier;
  final double score;
  final int matchedCount;
  final int totalRequired;
  final List<SubstitutedIngredient> substituted;
  final List<MissingIngredient> missing;

  /// True if the recipe consumes at least one soon-to-expire inventory item.
  final bool usesExpiringItems;
  final List<String> expiringItemNames;

  double get completeness => totalRequired == 0 ? 0 : matchedCount / totalRequired;
}

/// Tunable weights for the ranking score (PLAN.md Algorithm 1).
class MatchingOptions {
  const MatchingOptions({
    this.allowSubstitutions = true,
    this.expiryLookaheadDays = 3,
    this.completenessWeight = 0.5,
    this.expiryWeight = 0.35,
    this.substitutionPenaltyWeight = 0.15,
    this.maxSubsForTier2 = 2,
  });

  final bool allowSubstitutions;
  final int expiryLookaheadDays;
  final double completenessWeight;
  final double expiryWeight;
  final double substitutionPenaltyWeight;
  final int maxSubsForTier2;
}
