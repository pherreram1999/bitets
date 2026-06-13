import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/salon_repository.dart';
import '../../domain/entities/salon.dart';

part 'salon_providers.g.dart';

final salonRepositoryProvider = Provider<SalonRepository>(
  (ref) => SalonRepository(),
);

final salonesListProvider = FutureProvider<List<Salon>>(
  (ref) => GridNotifierOps.loadAll(ref.read(salonRepositoryProvider)),
);

@riverpod
class SalonesByEdificio extends _$SalonesByEdificio {
  @override
  Future<List<Salon>> build(int edificioId) async {
    if (edificioId == 0) return const <Salon>[];
    final result = await ref
        .read(salonRepositoryProvider)
        .fetchPage(1, query: {'edificio_id': edificioId, 'per_page': 15});
    return result.items;
  }
}

@riverpod
class SalonesDataset extends _$SalonesDataset {
  @override
  Future<List<Salon>> build(String query) async {
    final trimmed = query.trim();
    final params = <String, dynamic>{
      'per_page': 15,
      'sort': 'nombre',
      if (trimmed.isNotEmpty) 'nombre': trimmed,
    };
    final result = await ref
        .read(salonRepositoryProvider)
        .fetchPage(1, query: params);
    return result.items;
  }
}

@riverpod
class SalonesGrid extends _$SalonesGrid {
  @override
  Future<PaginatedResult<Salon>> build(int page) {
    final filters = ref.watch(salonesFiltersProvider);
    return GridNotifierOps.refreshPage(
      ref.read(salonRepositoryProvider),
      page,
      query: filters.isEmpty ? null : filters,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(salonRepositoryProvider),
        page,
        id,
      ),
    );
  }
}

@riverpod
class SalonesFilters extends _$SalonesFilters {
  @override
  Map<String, dynamic> build() => {};

  void apply(Map<String, dynamic> filters) => state = filters;
}
