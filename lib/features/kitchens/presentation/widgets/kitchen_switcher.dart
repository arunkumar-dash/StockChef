import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/kitchen_repository.dart';
import '../kitchen_providers.dart';

/// App-bar control for switching between the Home and Guest kitchens, and for
/// clearing the guest kitchen when leaving a rental. Recipes stay shared; only
/// inventory + restock follow the active kitchen.
class KitchenSwitcher extends ConsumerWidget {
  const KitchenSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeKitchenProvider);
    final kitchensAsync = ref.watch(kitchensProvider);
    final kitchens = kitchensAsync.valueOrNull ?? const [];
    final guestExists = kitchens.any((k) => k.isGuest);
    final activeName = kitchens
            .where((k) => k.id == active)
            .map((k) => k.name)
            .firstOrNull ??
        'Home';

    return PopupMenuButton<String>(
      tooltip: 'Switch kitchen',
      onSelected: (value) => _handle(context, ref, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          child: Text('Kitchen', style: TextStyle(fontSize: 12)),
        ),
        CheckedPopupMenuItem(
          value: AppDatabase.homeKitchenId,
          checked: active == AppDatabase.homeKitchenId,
          child: const Text('Home'),
        ),
        CheckedPopupMenuItem(
          value: KitchenRepository.guestKitchenId,
          checked: active == KitchenRepository.guestKitchenId,
          child: Text(guestExists ? 'Guest kitchen' : 'Start guest kitchen'),
        ),
        if (guestExists) ...[
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: '__clear_guest__',
            child: Row(
              children: [
                Icon(Icons.delete_sweep_outlined, size: 18),
                SizedBox(width: 8),
                Text('Clear guest kitchen'),
              ],
            ),
          ),
        ],
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active == KitchenRepository.guestKitchenId
                  ? Icons.luggage
                  : Icons.home_outlined,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(activeName, style: Theme.of(context).textTheme.labelLarge),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Future<void> _handle(BuildContext context, WidgetRef ref, String value) async {
    final repo = ref.read(kitchenRepositoryProvider);
    switch (value) {
      case AppDatabase.homeKitchenId:
        ref.read(activeKitchenProvider.notifier).state = AppDatabase.homeKitchenId;
      case KitchenRepository.guestKitchenId:
        await repo.ensureGuestKitchen();
        ref.read(activeKitchenProvider.notifier).state =
            KitchenRepository.guestKitchenId;
      case '__clear_guest__':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear guest kitchen?'),
            content: const Text(
              'Removes all inventory and restock items in the guest kitchen. '
              'Your recipes and Home kitchen are untouched.',
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Clear')),
            ],
          ),
        );
        if (confirmed == true) {
          await repo.clearKitchen(KitchenRepository.guestKitchenId);
          // Return to Home after clearing.
          ref.read(activeKitchenProvider.notifier).state =
              AppDatabase.homeKitchenId;
        }
    }
  }
}
