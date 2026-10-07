import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';
import 'core/seeding/recipe_seeder.dart';
import 'features/settings/data/settings_repository.dart';
import 'features/settings/presentation/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and seed the bundled dataset on first run (or after a
  // dataset-version bump). Seeding is idempotent and skipped when up to date.
  final database = AppDatabase();
  await RecipeSeeder(database).seedIfNeeded();

  // Load the persisted theme before the first frame to avoid a flash.
  final themeMode = await SettingsRepository(database).getThemeMode();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        themeModeProvider.overrideWith((ref) => themeMode),
      ],
      child: const StockChefApp(),
    ),
  );
}
