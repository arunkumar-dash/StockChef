import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../inventory/presentation/inventory_providers.dart';
import '../../kitchens/presentation/kitchen_providers.dart';
import '../data/matching_repository.dart';
import '../domain/match_models.dart';
import '../domain/recipe_matcher.dart';

final matchingRepositoryProvider = Provider<MatchingRepository>(
  (ref) => MatchingRepository(ref.watch(databaseProvider)),
);

/// Ranked recommendations for the active kitchen. Recomputed whenever that
/// kitchen's inventory changes (it watches the inventory stream).
final recommendationsProvider =
    FutureProvider<List<RecipeMatchResult>>((ref) async {
  final kitchen = ref.watch(activeKitchenProvider);
  ref.watch(stockViewsProvider); // re-run when inventory changes
  final input = await ref.watch(matchingRepositoryProvider).loadInput(kitchen);
  return const RecipeMatcher().rank(input);
});
