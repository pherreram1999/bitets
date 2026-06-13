import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/examen_repository.dart';
import '../../domain/entities/examen.dart';

part 'examen_providers.g.dart';

final examenRepositoryProvider = Provider<ExamenRepository>(
  (ref) => ExamenRepository(),
);

@riverpod
class ExamenesGrid extends _$ExamenesGrid {
  @override
  Future<PaginatedResult<Examen>> build(int page) {
    final filters = ref.watch(examenesFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(examenRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(examenRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class ExamenesFilters extends _$ExamenesFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
