import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/areas_repository.dart';
import '../../domain/entities/area.dart';

part 'areas_providers.g.dart';

final areasRepositoryProvider = Provider<AreasRepository>(
  (ref) => AreasRepository(),
);

final areasListProvider = FutureProvider<List<Area>>((ref) async {
  final repo = ref.read(areasRepositoryProvider);
  final all = <Area>[];
  int page = 1;
  while (true) {
    final result = await repo.fetchPage(page);
    all.addAll(result.items);
    if (!result.hasNextPage) break;
    page++;
  }
  return all;
});

@riverpod
class AreasGrid extends _$AreasGrid {
  @override
  Future<PaginatedResult<Area>> build(int page) {
    return GridNotifierOps.refreshPage(ref.read(areasRepositoryProvider), page);
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(areasRepositoryProvider),
        page,
        id,
      ),
    );
  }
}
