import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/edificio_repository.dart';
import '../../domain/entities/edificio.dart';

part 'edificio_providers.g.dart';

final edificioRepositoryProvider = Provider<EdificioRepository>(
  (ref) => EdificioRepository(),
);

final edificiosListProvider = FutureProvider<List<Edificio>>(
  (ref) => GridNotifierOps.loadAll(ref.read(edificioRepositoryProvider)),
);

@riverpod
class EdificiosGrid extends _$EdificiosGrid {
  @override
  Future<PaginatedResult<Edificio>> build(int page) {
    final filters = ref.watch(edificiosFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(edificioRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(edificioRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class EdificiosFilters extends _$EdificiosFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
