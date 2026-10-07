import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Provides the app-wide [AppDatabase]. The real instance is created and seeded
/// in `main()` and injected via a [ProviderScope] override, so this default
/// implementation should never actually run.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider must be overridden in main() with a seeded AppDatabase',
  ),
);
