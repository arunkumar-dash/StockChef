import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Wraps flutter_local_notifications: initialization, permissions, a recurring
/// daily digest, and exact per-item expiry reminders.
///
/// No background daemon (per project constraints). The daily digest fires at a
/// fixed time with static-ish content refreshed on app resume; the most urgent
/// expiring items also get exact one-shot reminders (kept well under iOS's
/// 64-pending cap — see IMPLEMENTATION.md A2).
class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _digestChannelId = 'stockchef_digest';
  static const _expiryChannelId = 'stockchef_expiry';
  static const int _digestNotificationId = 1;
  // Exact per-item reminders occupy ids 100+.
  static const int _expiryIdBase = 100;

  bool _initialized = false;

  /// Called when a notification is tapped; the payload is the deep-link route.
  void Function(String route)? onSelect;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    try {
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (_) {
      // Fall back to UTC if the platform timezone can't be resolved.
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null && onSelect != null) onSelect!(payload);
      },
    );
    _initialized = true;
  }

  /// Requests notification permission (Android 13+ and iOS). Safe to call each
  /// launch; the OS only prompts once.
  Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Returns the route to open if the app was cold-started from a notification.
  Future<String?> initialDeepLink() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details?.notificationResponse?.payload;
    }
    return null;
  }

  /// Schedules (or reschedules) the recurring daily digest at [hour]:[minute].
  Future<void> scheduleDailyDigest({
    required String body,
    int hour = 9,
    int minute = 0,
  }) async {
    if (!_initialized) return;
    await _plugin.zonedSchedule(
      _digestNotificationId,
      'StockChef',
      body,
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _digestChannelId,
          'Daily digest',
          channelDescription: 'Daily restock and expiry summary',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeats daily
      payload: '/restock',
    );
  }

  /// Schedules exact one-shot reminders for the given expiring items, replacing
  /// any previously scheduled ones. [items] should already be the top-K most
  /// urgent (K well under 64).
  Future<void> syncExpiryReminders(List<ExpiryReminder> items) async {
    if (!_initialized) return;
    // Clear the previous window of expiry reminders.
    for (var i = 0; i < 40; i++) {
      await _plugin.cancel(_expiryIdBase + i);
    }
    for (var i = 0; i < items.length && i < 40; i++) {
      final item = items[i];
      if (item.fireAt.isBefore(DateTime.now())) continue;
      await _plugin.zonedSchedule(
        _expiryIdBase + i,
        'Use it soon',
        '${item.itemName} expires ${item.humanWhen}',
        tz.TZDateTime.from(item.fireAt, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _expiryChannelId,
            'Expiry reminders',
            channelDescription: 'Reminders to use soon-to-expire items',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: '/inventory',
      );
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

/// A single expiry reminder to schedule.
class ExpiryReminder {
  const ExpiryReminder({
    required this.itemName,
    required this.fireAt,
    required this.humanWhen,
  });
  final String itemName;
  final DateTime fireAt;
  final String humanWhen;
}
