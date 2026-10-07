import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../kitchen_providers.dart';

/// A slim strip shown only while the Guest kitchen is active, so it's obvious
/// at a glance that inventory/restock are temporary. Renders nothing (zero
/// height) in the Home kitchen.
class GuestKitchenBanner extends ConsumerWidget {
  const GuestKitchenBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeKitchenProvider);
    if (active == AppDatabase.homeKitchenId) return const SizedBox.shrink();

    const accent = Color(0xFF1565C0);
    return Container(
      width: double.infinity,
      color: accent.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: const Row(
        children: [
          Icon(Icons.luggage, size: 16, color: accent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Guest kitchen — temporary stock for this stay',
              style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
