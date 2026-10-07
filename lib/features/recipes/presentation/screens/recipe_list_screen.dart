import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/dietary.dart';
import '../recipe_labels.dart';
import '../recipe_providers.dart';
import '../recipe_visual.dart';

/// Local UI state: the search query and optional cuisine / diet filters.
final _searchProvider = StateProvider.autoDispose<String>((ref) => '');
final _cuisineFilterProvider =
    StateProvider.autoDispose<CuisineRegion?>((ref) => null);
final _dietFilterProvider = StateProvider.autoDispose<DietaryTag?>((ref) => null);

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipeListProvider);
    final query = ref.watch(_searchProvider).toLowerCase();
    final cuisine = ref.watch(_cuisineFilterProvider);
    final diet = ref.watch(_dietFilterProvider);
    final tags = ref.watch(recipeDietaryTagsProvider).valueOrNull ?? const {};

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recipes/add'),
        icon: const Icon(Icons.add),
        label: const Text('New recipe'),
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load recipes',
          message: '$e',
        ),
        data: (recipes) {
          final filtered = recipes.where((r) {
            final matchesQuery = query.isEmpty || r.name.toLowerCase().contains(query);
            final matchesCuisine = cuisine == null || r.cuisine == cuisine;
            final matchesDiet =
                diet == null || (tags[r.id]?.contains(diet) ?? false);
            return matchesQuery && matchesCuisine && matchesDiet;
          }).toList();

          return Column(
            children: [
              _SearchAndFilter(recipes: recipes),
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No matching recipes',
                        message: 'Try a different search or cuisine filter.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) =>
                            _RecipeTile(recipe: filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchAndFilter extends ConsumerWidget {
  const _SearchAndFilter({required this.recipes});
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(_cuisineFilterProvider);
    // Only offer cuisine chips that actually appear in the data.
    final cuisines = recipes.map((r) => r.cuisine).toSet().toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search recipes',
            onChanged: (v) =>
                ref.read(_searchProvider.notifier).state = v,
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: const Text('All'),
                  selected: selected == null,
                  onSelected: (_) =>
                      ref.read(_cuisineFilterProvider.notifier).state = null,
                ),
              ),
              for (final c in cuisines)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(c.label),
                    selected: selected == c,
                    onSelected: (_) => ref
                        .read(_cuisineFilterProvider.notifier)
                        .state = selected == c ? null : c,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        _DietFilterRow(),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// Horizontal row of dietary / nutrition-goal filter chips.
class _DietFilterRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(_dietFilterProvider);
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final tag in DietaryTag.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                avatar: Icon(_dietIcon(tag), size: 16),
                label: Text(tag.label),
                selected: selected == tag,
                onSelected: (_) => ref.read(_dietFilterProvider.notifier).state =
                    selected == tag ? null : tag,
              ),
            ),
        ],
      ),
    );
  }

  IconData _dietIcon(DietaryTag tag) => switch (tag) {
        DietaryTag.vegetarian => Icons.eco,
        DietaryTag.nonVegetarian => Icons.egg_alt,
        DietaryTag.satvik => Icons.self_improvement,
        DietaryTag.highProtein => Icons.fitness_center,
        DietaryTag.light => Icons.monitor_weight_outlined,
        DietaryTag.hearty => Icons.restaurant,
      };
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final visual = RecipeVisual.of(recipe);
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: visual.gradient,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(visual.emoji, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(recipe.name),
        subtitle: Text('${recipe.cuisine.label} · ${recipe.mealType.label}'),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (recipe.isUserCreated)
              const Icon(Icons.person, size: 18)
            else if (recipe.isVegetarian)
              const Icon(Icons.eco, size: 18, color: Colors.green),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => context.push('/recipes/${recipe.id}'),
      ),
    );
  }
}
