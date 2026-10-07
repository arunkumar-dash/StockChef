import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../inventory/presentation/inventory_providers.dart';
import '../../../kitchens/presentation/widgets/guest_kitchen_banner.dart';
import '../../../kitchens/presentation/widgets/kitchen_switcher.dart';
import '../../../matching/domain/match_models.dart';
import '../../../matching/presentation/matching_providers.dart';

/// Home tab — recipes ranked by what's in the user's inventory, prioritizing
/// soon-to-expire ingredients and accounting for substitutions.
class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recsAsync = ref.watch(recommendationsProvider);
    final hasInventory = ref.watch(stockViewsProvider).maybeWhen(
          data: (s) => s.isNotEmpty,
          orElse: () => false,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cook Now'),
        actions: const [KitchenSwitcher()],
      ),
      body: Column(children: [
        const GuestKitchenBanner(),
        Expanded(child: recsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            EmptyState(icon: Icons.error_outline, title: 'Error', message: '$e'),
        data: (results) {
          if (!hasInventory) {
            return EmptyState(
              icon: Icons.restaurant_menu,
              title: 'Add inventory to get suggestions',
              message:
                  'StockChef ranks recipes you can make now — prioritizing '
                  'ingredients that expire soon.',
              action: FilledButton.icon(
                onPressed: () => context.go('/inventory'),
                icon: const Icon(Icons.add),
                label: const Text('Add inventory'),
              ),
            );
          }

          // Group by tier, keeping only recipes with some coverage.
          final byTier = <MatchTier, List<RecipeMatchResult>>{};
          for (final r in results) {
            if (r.completeness == 0) continue;
            byTier.putIfAbsent(r.tier, () => []).add(r);
          }
          if (byTier.isEmpty) {
            return const EmptyState(
              icon: Icons.search_off,
              title: 'No matches yet',
              message: 'Add a few more staples to unlock recipe suggestions.',
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              for (final tier in MatchTier.values)
                if (byTier[tier] != null) ...[
                  _TierHeader(tier: tier, count: byTier[tier]!.length),
                  ...byTier[tier]!.take(tier == MatchTier.partial ? 10 : 50).map(
                        (r) => _MatchCard(result: r),
                      ),
                ],
            ],
          );
        },
        )),
      ]),
    );
  }
}

class _TierHeader extends StatelessWidget {
  const _TierHeader({required this.tier, required this.count});
  final MatchTier tier;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Text(tier.label,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('$count',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.result});
  final RecipeMatchResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = result;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: InkWell(
        onTap: () => context.push('/recipes/${r.recipe.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(r.recipe.name,
                        style: theme.textTheme.titleMedium),
                  ),
                  Text('${r.matchedCount}/${r.totalRequired}',
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: r.completeness,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              if (r.usesExpiringItems) ...[
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.priority_high,
                  color: const Color(0xFFEF6C00),
                  text: 'Uses expiring: ${r.expiringItemNames.join(', ')}',
                ),
              ],
              if (r.substituted.isNotEmpty) ...[
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Icons.swap_horiz,
                  color: theme.colorScheme.primary,
                  text: r.substituted
                      .map((s) => '${s.usedName} for ${s.requiredName}')
                      .join(', '),
                ),
              ],
              if (r.missing.isNotEmpty) ...[
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Icons.remove_shopping_cart_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  text: 'Missing: ${r.missing.map((m) => m.name).join(', ')}',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
