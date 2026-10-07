import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/notification_coordinator.dart';
import '../data/notification_service.dart';

/// App-wide singleton notification service.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final notificationCoordinatorProvider = Provider<NotificationCoordinator>(
  (ref) => NotificationCoordinator(
    ref.watch(databaseProvider),
    ref.watch(notificationServiceProvider),
  ),
);
