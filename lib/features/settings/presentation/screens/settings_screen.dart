import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          for (final entry in const {
            ThemeMode.system: 'Follow system',
            ThemeMode.light: 'Light',
            ThemeMode.dark: 'Dark',
          }.entries)
            RadioListTile<ThemeMode>(
              value: entry.key,
              groupValue: themeMode,
              title: Text(entry.value),
              onChanged: (m) => setThemeMode(ref, m ?? themeMode),
            ),
          const Divider(),
          const _SectionHeader('Reminders'),
          const ListTile(
            leading: Icon(Icons.notifications_active_outlined),
            title: Text('Daily digest'),
            subtitle: Text(
              'A once-a-day summary of expiring items and low staples, '
              'refreshed each time you open the app.',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text(
              'StockChef — fully offline kitchen inventory & recipe matching. '
              'Recipe nutrition values are approximate.',
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
}
