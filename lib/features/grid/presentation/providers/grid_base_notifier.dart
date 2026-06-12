import '../../domain/entities/has_id.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/grid_repository.dart';

abstract final class GridNotifierOps {
  GridNotifierOps._();

  static Future<PaginatedResult<T>> deleteAndRefresh<T extends HasId>(
    GridRepository<T> repository,
    int currentPage,
    String id,
  ) async {
    await repository.delete(id);
    return repository.fetchPage(currentPage);
  }

  static Future<PaginatedResult<T>> refreshPage<T extends HasId>(
    GridRepository<T> repository,
    int currentPage,
  ) => repository.fetchPage(currentPage);
}
