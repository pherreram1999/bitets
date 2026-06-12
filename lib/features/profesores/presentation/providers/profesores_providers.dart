import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/profesores_repository.dart';
import '../../domain/entities/profesor.dart';

part 'profesores_providers.g.dart';

final profesoresRepositoryProvider = Provider<ProfesoresRepository>(
  (ref) => ProfesoresRepository(),
);

@riverpod
class ProfesoresGrid extends _$ProfesoresGrid {
  @override
  Future<PaginatedResult<Profesor>> build(int page) {
    return GridNotifierOps.refreshPage(
      ref.read(profesoresRepositoryProvider),
      page,
    );
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => GridNotifierOps.deleteAndRefresh(
        ref.read(profesoresRepositoryProvider),
        page,
        id,
      ),
    );
  }
}
