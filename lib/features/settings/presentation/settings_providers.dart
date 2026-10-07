import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

/// The user's chosen theme mode. Its initial value is loaded from the database
/// and overridden in `main()`; changes are persisted via [setThemeMode].
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Updates the theme immediately and persists the choice.
Future<void> setThemeMode(WidgetRef ref, ThemeMode mode) async {
  ref.read(themeModeProvider.notifier).state = mode;
  await ref.read(settingsRepositoryProvider).setThemeMode(mode);
}
