import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/alumno_examen_repository.dart';
import '../../data/repositories/examen_repository.dart';
import '../../domain/entities/examen.dart';

part 'examen_providers.g.dart';

final examenRepositoryProvider = Provider<ExamenRepository>(
  (ref) => ExamenRepository(),
);

final alumnoExamenRepositoryProvider = Provider<AlumnoExamenRepository>(
  (ref) => AlumnoExamenRepository(),
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

@riverpod
class AlumnoExamenesGrid extends _$AlumnoExamenesGrid {
  @override
  Future<PaginatedResult<Examen>> build(int page) {
    final filters = ref.watch(alumnoExamenesFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(alumnoExamenRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(alumnoExamenRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class AlumnoExamenesFilters extends _$AlumnoExamenesFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}

@riverpod
class EnrolledExamenIds extends _$EnrolledExamenIds {
  @override
  Future<Set<String>> build() async {
    final repo = ref.read(alumnoExamenRepositoryProvider);
    final all = await repo.getAllLocal();
    return all.map((e) => e.id).toSet();
  }
}

@riverpod
class AlumnoCatalogoExamenesFilters extends _$AlumnoCatalogoExamenesFilters {
  static const Map<String, dynamic> defaults = {'activo': '1'};

  @override
  Map<String, dynamic> build() => const {};

  void apply(Map<String, dynamic> filters) => state = filters;
}

@riverpod
class AlumnoCatalogoExamenesGrid extends _$AlumnoCatalogoExamenesGrid {
  @override
  Future<PaginatedResult<Examen>> build(int page) {
    final userFilters = ref.watch(alumnoCatalogoExamenesFiltersProvider);
    final filters = {...AlumnoCatalogoExamenesFilters.defaults, ...userFilters};
    return GridNotifierOps.refreshPage(
      ref.read(examenRepositoryProvider),
      page,
      query: filters,
    );
  }
}
