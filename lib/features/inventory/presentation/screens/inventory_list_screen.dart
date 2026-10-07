import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/expiry_badge.dart';
import '../../../kitchens/presentation/widgets/guest_kitchen_banner.dart';
import '../../../kitchens/presentation/widgets/kitchen_switcher.dart';
import '../../domain/entities/inventory_views.dart';
import '../inventory_providers.dart';

class InventoryListScreen extends ConsumerWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockViewsProvider);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
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
        onPressed: () => context.push('/inventory/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: Column(children: [
        const GuestKitchenBanner(),
        Expanded(child: stockAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load inventory',
          message: '$e',
        ),
        data: (stock) {
          if (stock.isEmpty) {
            return EmptyState(
              icon: Icons.kitchen,
              title: 'Your kitchen is empty',
              message: 'Add items to track quantity, shelf-life and expiry.',
              action: FilledButton.icon(
                onPressed: () => context.push('/inventory/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add your first item'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: stock.length,
            itemBuilder: (context, i) => _StockTile(view: stock[i], now: now),
          );
        },
        )),
      ]),
    );
  }
}

class _StockTile extends ConsumerWidget {
  const _StockTile({required this.view, required this.now});
  final IngredientStockView view;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final multipleBatches = view.batches.length > 1;

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(Icons.inventory_2_outlined,
              color: theme.colorScheme.onSecondaryContainer),
        ),
        title: Text(view.displayName),
        subtitle: Text(
          '${_fmtQty(view.totalQuantity)} ${view.unit}'
          '${multipleBatches ? ' · ${view.batches.length} batches' : ''}',
        ),
        trailing: view.soonestExpiry != null
            ? ExpiryBadge(
                daysUntilExpiry: view.batches.first.daysUntilExpiry(now),
              )
            : null,
        children: [
          for (final b in view.batches)
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 72, right: 8),
              title: Text('${_fmtQty(b.batch.quantity)} ${b.batch.unit.name}'),
              subtitle: Text(
                'Expires ${_fmtDate(b.batch.expiryDate)}'
                ' · bought ${_fmtDate(b.batch.purchaseDate)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () =>
                        context.push('/inventory/edit/${b.batch.id}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => ref
                        .read(inventoryRepositoryProvider)
                        .deleteBatch(b.batch.id),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

String _fmtQty(double q) => q == q.roundToDouble() ? q.toStringAsFixed(0) : '$q';
String _fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
