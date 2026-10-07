import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/screens/add_edit_inventory_screen.dart';
import '../../features/inventory/presentation/screens/inventory_list_screen.dart';
import '../../features/ocr_scan/presentation/screens/scan_capture_screen.dart';
import '../../features/recipes/presentation/screens/add_recipe_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../../features/recipes/presentation/screens/recipe_list_screen.dart';
import '../../features/recipes/presentation/screens/recommendations_screen.dart';
import '../../features/restock/presentation/screens/restock_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Route path constants. Referencing these avoids stringly-typed navigation
/// and gives one place to update when paths change (e.g. notification
/// deep-links in Phase 5).
class Routes {
  const Routes._();
  static const cook = '/cook';
  static const recipes = '/recipes';
  static const inventory = '/inventory';
  static const restock = '/restock';
  static const settings = '/settings';
  static const scan = '/scan';
}

/// A single bottom-nav destination.
class _Destination {
  const _Destination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
    this.subRoutes = const [],
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget Function() builder;

  /// Nested routes shown within this tab (keeping the bottom nav visible).
  final List<RouteBase> subRoutes;
}

/// The five primary destinations shown in the bottom navigation bar.
/// Each feature owns its screen; the shell just composes them here, so adding
/// a feature tab later is a one-line change.
final List<_Destination> _destinations = [
  _Destination(
    path: Routes.cook,
    label: 'Cook',
    icon: Icons.restaurant_menu_outlined,
    selectedIcon: Icons.restaurant_menu,
    builder: RecommendationsScreen.new,
  ),
  _Destination(
    path: Routes.recipes,
    label: 'Recipes',
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book,
    builder: RecipeListScreen.new,
    subRoutes: [
      // 'add' must precede ':id' so it isn't captured as a recipe id.
      GoRoute(
        path: 'add',
        builder: (context, state) => const AddRecipeScreen(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            RecipeDetailScreen(recipeId: state.pathParameters['id']!),
      ),
    ],
  ),
  _Destination(
    path: Routes.inventory,
    label: 'Inventory',
    icon: Icons.kitchen_outlined,
    selectedIcon: Icons.kitchen,
    builder: InventoryListScreen.new,
    subRoutes: [
      GoRoute(
        path: 'add',
        builder: (context, state) => const AddEditInventoryScreen(),
      ),
      GoRoute(
        path: 'edit/:id',
        builder: (context, state) =>
            AddEditInventoryScreen(batchId: state.pathParameters['id']),
      ),
    ],
  ),
  _Destination(
    path: Routes.restock,
    label: 'Restock',
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
    builder: RestockListScreen.new,
  ),
  _Destination(
    path: Routes.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    builder: SettingsScreen.new,
  ),
];

/// Builds the app's [GoRouter]. Uses [StatefulShellRoute.indexedStack] so each
/// tab keeps its own navigation state and scroll position when switching.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: Routes.cook,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          for (final d in _destinations)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: d.path,
                  builder: (context, state) => d.builder(),
                  routes: d.subRoutes,
                ),
              ],
            ),
        ],
      ),
      // Full-screen routes outside the shell (no bottom bar), e.g. the OCR flow.
      GoRoute(
        path: Routes.scan,
        builder: (context, state) => const ScanCaptureScreen(),
      ),
    ],
  );
}

/// The persistent bottom-navigation scaffold wrapping the active tab.
class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
