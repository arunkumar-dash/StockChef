import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';

/// Reads/writes user preferences to the [AppSettings] key/value table so they
/// survive app restarts (fully offline).
class SettingsRepository {
  SettingsRepository(this._db);
  final AppDatabase _db;

  static const _themeKey = 'theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final row = await (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(_themeKey)))
        .getSingleOrNull();
    return switch (row?.value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _themeKey, value: mode.name),
        );
  }
}
