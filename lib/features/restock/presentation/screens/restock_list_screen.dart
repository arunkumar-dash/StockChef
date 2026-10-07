import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../kitchens/presentation/kitchen_providers.dart';
import '../../../kitchens/presentation/widgets/guest_kitchen_banner.dart';
import '../../../kitchens/presentation/widgets/kitchen_switcher.dart';
import '../restock_providers.dart';

class RestockListScreen extends ConsumerWidget {
  const RestockListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(activeRestockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restock'),
        actions: [
          const KitchenSwitcher(),
          IconButton(
            tooltip: 'Scan a grocery bill',
            icon: const Icon(Icons.document_scanner_outlined),
            onPressed: () => context.push('/scan'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: Column(children: [
        const GuestKitchenBanner(),
        Expanded(child: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            EmptyState(icon: Icons.error_outline, title: 'Error', message: '$e'),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Nothing to restock',
              message:
                  'Items appear here automatically when they run low. You can '
                  'also add items manually or by scanning a grocery bill.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: items.length,
            itemBuilder: (context, i) => _RestockTile(item: items[i]),
          );
        },
        )),
      ]),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to restock list'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Item name'),
            ),
            TextField(
              controller: qtyController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Quantity (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (added == true && nameController.text.trim().isNotEmpty) {
      await ref.read(restockRepositoryProvider).addManual(
            kitchenId: ref.read(activeKitchenProvider),
            itemName: nameController.text.trim(),
            quantity: double.tryParse(qtyController.text),
          );
    }
  }
}

class _RestockTile extends ConsumerWidget {
  const _RestockTile({required this.item});
  final RestockListItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(restockRepositoryProvider);
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => repo.delete(item.id),
      child: Card(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: ListTile(
          leading: Checkbox(
            value: false,
            onChanged: (_) => repo.setResolved(item.id, true),
          ),
          title: Text(item.itemName),
          subtitle: Text(_subtitle(item)),
          trailing: _ReasonChip(reason: item.reason),
        ),
      ),
    );
  }

  String _subtitle(RestockListItem item) {
    if (item.suggestedQuantity == null) return 'Tap to mark bought';
    final q = item.suggestedQuantity!;
    final qStr = q == q.roundToDouble() ? q.toStringAsFixed(0) : '$q';
    return 'Suggested: $qStr ${item.unit?.name ?? ''}'.trim();
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.reason});
  final RestockReason reason;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (reason) {
      RestockReason.lowStock => ('Low', const Color(0xFFEF6C00)),
      RestockReason.manual => ('Manual', const Color(0xFF2E7D5B)),
      RestockReason.ocrImport => ('Scanned', const Color(0xFF1565C0)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
