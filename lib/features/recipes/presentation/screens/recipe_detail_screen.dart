import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/recipe_detail.dart';
import '../../domain/services/portion_scaler.dart';
import '../recipe_labels.dart';
import '../recipe_providers.dart';
import '../recipe_visual.dart';
import '../widgets/equipment_footnote.dart';
import '../widgets/serving_size_selector.dart';
import '../widgets/step_timeline.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      appBar: AppBar(),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load recipe',
          message: '$e',
        ),
        data: (detail) {
          if (detail == null) {
            return const EmptyState(
              icon: Icons.no_meals,
              title: 'Recipe not found',
            );
          }
          return _RecipeBody(detail: detail);
        },
      ),
    );
  }
}

class _RecipeBody extends ConsumerWidget {
  const _RecipeBody({required this.detail});
  final RecipeDetail detail;

  static const _scaler = PortionScaler();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recipe = detail.recipe;
    final servings = ref.watch(servingsProvider(recipe.id));

    final visual = RecipeVisual.of(recipe);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: visual.gradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(visual.emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  recipe.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _Tag(text: recipe.cuisine.label, icon: Icons.public),
            _Tag(text: recipe.mealType.label, icon: Icons.schedule),
            if (recipe.isVegetarian)
              const _Tag(text: 'Veg', icon: Icons.eco),
            if (recipe.prepTimeMinutes != null)
              _Tag(text: 'Prep ${recipe.prepTimeMinutes}m', icon: Icons.cut),
            if (recipe.cookTimeMinutes != null)
              _Tag(text: 'Cook ${recipe.cookTimeMinutes}m', icon: Icons.outdoor_grill),
          ],
        ),
        if (recipe.description != null) ...[
          const SizedBox(height: 12),
          Text(recipe.description!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ServingSizeSelector(
              servings: servings,
              onChanged: (v) =>
                  ref.read(servingsProvider(recipe.id).notifier).state = v,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader('Ingredients'),
        const SizedBox(height: 8),
        ...detail.ingredients.map((iv) => _IngredientRow(
              view: iv,
              scaled: _scaler.scale(
                quantityPerServing: iv.line.quantityPerServing,
                unit: iv.line.unit,
                servings: servings,
              ),
            )),
        if (_hasNutrition(recipe)) ...[
          const SizedBox(height: 20),
          _SectionHeader('Nutrition (per serving, approx.)'),
          const SizedBox(height: 8),
          _NutritionRow(recipe: recipe),
        ],
        if (detail.equipment.isNotEmpty) ...[
          const SizedBox(height: 20),
          _SectionHeader('Equipment'),
          const SizedBox(height: 8),
          EquipmentFootnote(equipment: detail.equipment),
        ],
        const SizedBox(height: 20),
        _SectionHeader('Method'),
        const SizedBox(height: 4),
        StepTimeline(groups: detail.groupedSteps),
        if (recipe.isUserCreated) ...[
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete recipe?'),
                  content: Text('Remove "${recipe.name}" from your recipes?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref
                    .read(recipeRepositoryProvider)
                    .deleteUserRecipe(recipe.id);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete recipe'),
          ),
        ],
      ],
    );
  }

  bool _hasNutrition(recipe) =>
      recipe.caloriesPerServing != null ||
      recipe.proteinGrams != null ||
      recipe.carbsGrams != null ||
      recipe.fatGrams != null;
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.view, required this.scaled});
  final RecipeIngredientView view;
  final ScaledQuantity scaled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: view.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (view.line.isOptional)
                    TextSpan(
                      text: ' (optional)',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  if (view.line.preparationNote != null)
                    TextSpan(
                      text: ' — ${view.line.preparationNote}',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatScaledQuantity(scaled),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.recipe});
  final dynamic recipe;

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, double? value, String unit) {
      if (value == null) return const SizedBox.shrink();
      final theme = Theme.of(context);
      return Column(
        children: [
          Text(
            '${value % 1 == 0 ? value.toStringAsFixed(0) : value}$unit',
            style: theme.textTheme.titleMedium,
          ),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        cell('Calories', recipe.caloriesPerServing, ''),
        cell('Protein', recipe.proteinGrams, 'g'),
        cell('Carbs', recipe.carbsGrams, 'g'),
        cell('Fat', recipe.fatGrams, 'g'),
        cell('Fiber', recipe.fiberGrams, 'g'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
