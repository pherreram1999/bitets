import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/plan_estudio_repository.dart';
import '../../domain/entities/plan_estudio.dart';

part 'plan_estudio_providers.g.dart';

final planEstudioRepositoryProvider = Provider<PlanEstudioRepository>(
  (ref) => PlanEstudioRepository(),
);

final planesEstudioListProvider = FutureProvider<List<PlanEstudio>>(
  (ref) => GridNotifierOps.loadAll(ref.read(planEstudioRepositoryProvider)),
);

@riverpod
class PlanesEstudioGrid extends _$PlanesEstudioGrid {
  @override
  Future<PaginatedResult<PlanEstudio>> build(int page) {
    final filters = ref.watch(planesEstudioFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(planEstudioRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(planEstudioRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class PlanesEstudioFilters extends _$PlanesEstudioFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
