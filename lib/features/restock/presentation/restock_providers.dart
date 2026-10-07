import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../kitchens/presentation/kitchen_providers.dart';
import '../data/restock_repository.dart';

final restockRepositoryProvider = Provider<RestockRepository>(
  (ref) => RestockRepository(ref.watch(databaseProvider)),
);

/// Active (unresolved) restock items for the active kitchen (reactive).
final activeRestockProvider = StreamProvider<List<RestockListItem>>((ref) {
  final kitchen = ref.watch(activeKitchenProvider);
  return ref.watch(restockRepositoryProvider).watchActive(kitchen);
});
