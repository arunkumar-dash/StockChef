import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../recipe_labels.dart';

/// Renders cooking steps as a vertical timeline. Steps that share a parallel
/// group are boxed together with a "do in parallel" banner, and each step shows
/// its gas-flame level (see PLAN.md — steps carry HIGH/MEDIUM/LOW flame).
class StepTimeline extends StatelessWidget {
  const StepTimeline({super.key, required this.groups});

  /// Ordered groups of steps; a group with >1 step is parallelizable.
  final List<List<RecipeStep>> groups;

  @override
  Widget build(BuildContext context) {
    var displayNumber = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups)
          if (group.length == 1)
            _StepRow(step: group.first, number: ++displayNumber)
          else
            _ParallelGroup(
              steps: group,
              startNumber: () {
                final start = displayNumber + 1;
                displayNumber += group.length;
                return start;
              }(),
            ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.number});
  final RecipeStep step;
  final int number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final flame = step.flameLevel;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              '$number',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.instruction, style: theme.textTheme.bodyMedium),
                if (flame != null || step.estimatedDurationSeconds != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 12,
                      children: [
                        if (flame != null)
                          _MetaChip(
                            icon: flame.icon,
                            label: flame.label,
                            color: flame.color(theme.colorScheme),
                          ),
                        if (step.estimatedDurationSeconds != null)
                          _MetaChip(
                            icon: Icons.timer_outlined,
                            label: _fmtDuration(step.estimatedDurationSeconds!),
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParallelGroup extends StatelessWidget {
  const _ParallelGroup({required this.steps, required this.startNumber});
  final List<RecipeStep> steps;
  final int startNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.call_split, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Do these in parallel',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          for (var i = 0; i < steps.length; i++)
            _StepRow(step: steps[i], number: startNumber + i),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color),
        ),
      ],
    );
  }
}

String _fmtDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return s == 0 ? '${m}m' : '${m}m ${s}s';
}
