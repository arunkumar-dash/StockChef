import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../kitchens/presentation/kitchen_providers.dart';
import '../data/inventory_repository.dart';
import '../domain/entities/inventory_views.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepository(ref.watch(databaseProvider)),
);

/// Inventory for the active kitchen, rolled up per ingredient (reactive).
final stockViewsProvider = StreamProvider<List<IngredientStockView>>((ref) {
  final kitchen = ref.watch(activeKitchenProvider);
  return ref.watch(inventoryRepositoryProvider).watchStockViews(kitchen);
});

/// Canonical ingredients for the add/edit autocomplete.
final ingredientsProvider = FutureProvider<List<Ingredient>>(
  (ref) => ref.watch(inventoryRepositoryProvider).getAllIngredients(),
);
