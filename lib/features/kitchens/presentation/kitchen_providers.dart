import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/kitchen_repository.dart';

final kitchenRepositoryProvider = Provider<KitchenRepository>(
  (ref) => KitchenRepository(ref.watch(databaseProvider)),
);

/// The currently-active kitchen id. Inventory, restock and recommendations are
/// all scoped to this. Defaults to the permanent home kitchen.
final activeKitchenProvider =
    StateProvider<String>((ref) => AppDatabase.homeKitchenId);

/// All kitchens (reactive), for the switcher.
final kitchensProvider = StreamProvider<List<Kitchen>>(
  (ref) => ref.watch(kitchenRepositoryProvider).watchKitchens(),
);
