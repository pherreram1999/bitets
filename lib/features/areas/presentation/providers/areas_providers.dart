import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/areas_repository.dart';
import '../../domain/entities/area.dart';

part 'areas_providers.g.dart';

final areaRepositoryProvider = Provider<AreasRepository>(
  (ref) => AreasRepository(),
);

final areasListProvider = FutureProvider<List<Area>>(
  (ref) => GridNotifierOps.loadAll(ref.read(areaRepositoryProvider)),
);

@riverpod
class AreasGrid extends _$AreasGrid {
  @override
  Future<PaginatedResult<Area>> build(int page) {
    final filters = ref.watch(areasFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(areaRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(areaRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class AreasFilters extends _$AreasFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
