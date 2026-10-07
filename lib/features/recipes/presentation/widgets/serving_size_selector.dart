import 'package:flutter/material.dart';

/// A compact stepper for choosing how many servings to scale a recipe to.
class ServingSizeSelector extends StatelessWidget {
  const ServingSizeSelector({
    super.key,
    required this.servings,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
  });

  final int servings;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.people_outline, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text('Servings', style: theme.textTheme.labelLarge),
        const Spacer(),
        IconButton.filledTonal(
          onPressed: servings > min ? () => onChanged(servings - 1) : null,
          icon: const Icon(Icons.remove),
          visualDensity: VisualDensity.compact,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$servings', style: theme.textTheme.titleMedium),
        ),
        IconButton.filledTonal(
          onPressed: servings < max ? () => onChanged(servings + 1) : null,
          icon: const Icon(Icons.add),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
