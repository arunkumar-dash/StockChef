import 'package:drift/drift.dart';

import '../enums.dart';

/// Maps an inventory item to a scheduled OS notification so we can cancel /
/// reschedule it when the item is edited, consumed, or deleted.
class ScheduledReminders extends Table {
  TextColumn get id => text()();
  TextColumn get inventoryItemId => text().nullable()();

  /// The integer id passed to flutter_local_notifications (needed to cancel).
  IntColumn get notificationId => integer()();
  TextColumn get type => textEnum<ReminderType>()();
  DateTimeColumn get scheduledFor => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Rate-limiter state for recurring reminders: the last time we notified about
/// a given ingredient, so the daily digest doesn't re-spam within its cooldown.
class NotificationDebounces extends Table {
  TextColumn get ingredientId => text()();
  DateTimeColumn get lastNotifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {ingredientId};
}

/// Simple key/value store for app-level metadata, notably the seeded dataset
/// version so the seeder only re-runs when the bundled data changes.
class SeedMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// App-level user preferences (theme mode, etc.) as a small key/value store,
/// kept separate from [SeedMetadata] which is dataset bookkeeping.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// A separate kitchen/inventory space. There is always a permanent "home"
/// kitchen; a "guest" kitchen supports the travel/Airbnb use case where the
/// user tracks a temporary rental's stock and can clear it when they leave.
/// Recipes and the ingredient/equipment dictionaries are shared across all
/// kitchens — only inventory and the restock list are scoped per kitchen.
class Kitchens extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isGuest => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
