import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import 'notification_service.dart';

/// Bridges inventory/restock data to the [NotificationService]: computes the
/// daily digest text and the top-K expiry reminders, then (re)schedules them.
/// Called at startup and on app resume.
class NotificationCoordinator {
  NotificationCoordinator(this._db, this._service);
  final AppDatabase _db;
  final NotificationService _service;

  static const int _expiryLookaheadDays = 3;
  static const int _topK = 15;

  Future<void> refresh(String kitchenId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final inventory = await (_db.select(_db.inventoryItems)
          ..where((t) => t.kitchenId.equals(kitchenId)))
        .get();
    final ingredients = await _db.select(_db.ingredients).get();
    final names = {for (final i in ingredients) i.id: i.name};

    // Expiring-soon batches (not already expired), soonest first.
    final expiring = inventory.where((b) {
      final d = DateTime(b.expiryDate.year, b.expiryDate.month, b.expiryDate.day)
          .difference(today)
          .inDays;
      return d >= 0 && d <= _expiryLookaheadDays;
    }).toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    // Active restock items (low staples etc.).
    final restockCount = (await (_db.select(_db.restockListItems)
              ..where((t) =>
                  t.isResolved.equals(false) & t.kitchenId.equals(kitchenId)))
            .get())
        .length;

    // Digest body.
    final parts = <String>[];
    if (expiring.isNotEmpty) {
      parts.add('${expiring.length} item${expiring.length == 1 ? '' : 's'} '
          'expiring soon');
    }
    if (restockCount > 0) {
      parts.add('$restockCount to restock');
    }
    final body = parts.isEmpty
        ? 'Your kitchen is in good shape today.'
        : parts.join(' · ');
    await _service.scheduleDailyDigest(body: body);

    // Top-K exact expiry reminders (fire the morning of soonest expiry window).
    final reminders = <ExpiryReminder>[];
    for (final b in expiring.take(_topK)) {
      final name = b.ingredientId != null
          ? (names[b.ingredientId] ?? b.customName ?? b.ingredientId!)
          : (b.customName ?? 'Item');
      final days = DateTime(b.expiryDate.year, b.expiryDate.month, b.expiryDate.day)
          .difference(today)
          .inDays;
      // Fire at 9am on the day, or now+1min if that already passed.
      var fireAt = DateTime(b.expiryDate.year, b.expiryDate.month, b.expiryDate.day, 9);
      if (fireAt.isBefore(now)) fireAt = now.add(const Duration(minutes: 1));
      reminders.add(ExpiryReminder(
        itemName: name,
        fireAt: fireAt,
        humanWhen: switch (days) {
          0 => 'today',
          1 => 'tomorrow',
          _ => 'in $days days',
        },
      ));
    }
    await _service.syncExpiryReminders(reminders);
  }
}
