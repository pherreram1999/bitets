import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/unidad_aprendizaje_repository.dart';
import '../../domain/entities/unidad_aprendizaje.dart';

part 'unidad_aprendizaje_providers.g.dart';

final unidadAprendizajeRepositoryProvider =
    Provider<UnidadAprendizajeRepository>(
      (ref) => UnidadAprendizajeRepository(),
    );

final unidadesAprendizajeListProvider = FutureProvider<List<UnidadAprendizaje>>(
  (ref) =>
      GridNotifierOps.loadAll(ref.read(unidadAprendizajeRepositoryProvider)),
);

typedef UnidadesAprendizajeDatasetArgs = ({
  int carreraId,
  int planEstudioId,
  String query,
});

@riverpod
class UnidadesAprendizajeDataset extends _$UnidadesAprendizajeDataset {
  @override
  Future<List<UnidadAprendizaje>> build(
    UnidadesAprendizajeDatasetArgs args,
  ) async {
    if (args.carreraId == 0 || args.planEstudioId == 0) {
      return const <UnidadAprendizaje>[];
    }
    final trimmed = args.query.trim();
    final params = <String, dynamic>{
      'carrera_id': args.carreraId,
      'plan_estudio_id': args.planEstudioId,
      'per_page': 5,
      'sort': '-id',
      if (trimmed.isNotEmpty) 'nombre': trimmed,
    };
    final result = await ref
        .read(unidadAprendizajeRepositoryProvider)
        .fetchPage(1, query: params);
    return result.items;
  }
}

@riverpod
class UnidadesAprendizajeGrid extends _$UnidadesAprendizajeGrid {
  @override
  Future<PaginatedResult<UnidadAprendizaje>> build(int page) {
    final filters = ref.watch(unidadesAprendizajeFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(unidadAprendizajeRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(unidadAprendizajeRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class UnidadesAprendizajeFilters extends _$UnidadesAprendizajeFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
