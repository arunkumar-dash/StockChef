import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/inventory/presentation/inventory_providers.dart';
import 'features/kitchens/presentation/kitchen_providers.dart';
import 'features/notifications/presentation/notification_providers.dart';
import 'features/settings/presentation/settings_providers.dart';

/// Holds the app's [GoRouter] instance. A provider so services (e.g.
/// notification deep-linking) can navigate without a BuildContext.
final routerProvider = Provider<GoRouter>((ref) => createRouter());

/// Root widget. Wires theming and routing, initializes notifications, and
/// reconciles derived state (restock, expiry reminders) at startup and on every
/// resume — no background daemon.
class StockChefApp extends ConsumerStatefulWidget {
  const StockChefApp({super.key});

  @override
  ConsumerState<StockChefApp> createState() => _StockChefAppState();
}

class _StockChefAppState extends ConsumerState<StockChefApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final service = ref.read(notificationServiceProvider);
    final router = ref.read(routerProvider);
    service.onSelect = (route) => router.go(route);
    await service.init();
    await service.requestPermissions();

    // Cold-start deep link (app launched by tapping a notification).
    final initialRoute = await service.initialDeepLink();
    if (initialRoute != null) router.go(initialRoute);

    // Reconcile restock + (re)schedule notifications for the active kitchen.
    final kitchen = ref.read(activeKitchenProvider);
    await ref.read(inventoryRepositoryProvider).recomputeAllRestock(kitchen);
    await ref.read(notificationCoordinatorProvider).refresh(kitchen);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Recompute low-stock/restock and refresh reminders in case stock changed
      // or dates rolled over while the app was backgrounded.
      final kitchen = ref.read(activeKitchenProvider);
      ref.read(inventoryRepositoryProvider).recomputeAllRestock(kitchen);
      ref.read(notificationCoordinatorProvider).refresh(kitchen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'StockChef',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
