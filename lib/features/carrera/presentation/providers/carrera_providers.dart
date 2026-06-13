import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/carrera_repository.dart';
import '../../domain/entities/carrera.dart';

part 'carrera_providers.g.dart';

final carreraRepositoryProvider = Provider<CarreraRepository>(
  (ref) => CarreraRepository(),
);

final carrerasListProvider = FutureProvider<List<Carrera>>(
  (ref) => GridNotifierOps.loadAll(ref.read(carreraRepositoryProvider)),
);

@riverpod
class CarreraGrid extends _$CarreraGrid {
  @override
  Future<PaginatedResult<Carrera>> build(int page) {
    final filters = ref.watch(carrerasFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(carreraRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(carreraRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class CarrerasFilters extends _$CarrerasFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
