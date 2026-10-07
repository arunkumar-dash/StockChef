import 'package:flutter/material.dart';

/// Small colored pill communicating how close an item is to expiry.
/// Reused by inventory, restock and (later) expiry reminders so the color
/// language is consistent: red = expired, amber = expiring soon, green = fresh.
class ExpiryBadge extends StatelessWidget {
  const ExpiryBadge({super.key, required this.daysUntilExpiry});

  final int daysUntilExpiry;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (daysUntilExpiry) {
      < 0 => (const Color(0xFFC62828), 'Expired'),
      0 => (const Color(0xFFEF6C00), 'Today'),
      1 => (const Color(0xFFEF6C00), '1 day'),
      <= 3 => (const Color(0xFFEF6C00), '$daysUntilExpiry days'),
      <= 7 => (const Color(0xFFF9A825), '$daysUntilExpiry days'),
      _ => (const Color(0xFF2E7D32), '$daysUntilExpiry days'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
