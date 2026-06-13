import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/profesores_repository.dart';
import '../../domain/entities/profesor.dart';

part 'profesores_providers.g.dart';

final profesorRepositoryProvider = Provider<ProfesoresRepository>(
  (ref) => ProfesoresRepository(),
);

final profesoresListProvider = FutureProvider<List<Profesor>>(
  (ref) => GridNotifierOps.loadAll(ref.read(profesorRepositoryProvider)),
);

@riverpod
class ProfesoresDataset extends _$ProfesoresDataset {
  @override
  Future<List<Profesor>> build(String query) async {
    final trimmed = query.trim();
    final params = <String, dynamic>{
      'per_page': 15,
      if (trimmed.isNotEmpty) 'nombre': trimmed,
    };
    final result = await ref
        .read(profesorRepositoryProvider)
        .fetchPage(1, query: params);
    return result.items;
  }
}

@riverpod
class ProfesoresGrid extends _$ProfesoresGrid {
  @override
  Future<PaginatedResult<Profesor>> build(int page) {
    final filters = ref.watch(profesoresFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(profesorRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(profesorRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class ProfesoresFilters extends _$ProfesoresFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
