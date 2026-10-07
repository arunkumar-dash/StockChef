import 'package:flutter/material.dart';

import '../../domain/entities/recipe_detail.dart';

/// Shows equipment needed for a recipe, plus substitution alternatives as a
/// footnote. Per PLAN.md Algorithm 6, equipment substitutes are informational —
/// shown regardless of whether the user owns the alternative — so a cook
/// without the primary tool knows what else works.
class EquipmentFootnote extends StatelessWidget {
  const EquipmentFootnote({super.key, required this.equipment});
  final List<RecipeEquipmentView> equipment;

  @override
  Widget build(BuildContext context) {
    if (equipment.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final e in equipment)
              Chip(
                avatar: Icon(
                  e.line.isEssential ? Icons.kitchen : Icons.kitchen_outlined,
                  size: 18,
                ),
                label: Text(e.displayName),
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (final e in equipment)
          if (e.substitutes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: '† No '),
                    TextSpan(
                      text: e.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: '? Try '),
                    TextSpan(
                      text: e.substitutes.map((s) => s.name).join(', '),
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    if (e.substitutes.first.note != null)
                      TextSpan(text: ' — ${e.substitutes.first.note}'),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
