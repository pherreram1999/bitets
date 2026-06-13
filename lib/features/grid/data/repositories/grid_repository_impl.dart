import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/grid_repository.dart';
import '../datasources/laravel_grid_datasource.dart';

class GridRepositoryImpl<T extends HasId> implements GridRepository<T> {
  GridRepositoryImpl({
    required LaravelResourceController controller,
    LaravelGridDatasource? datasource,
  }) : _datasource = datasource ?? LaravelGridDatasource(controller);

  final LaravelGridDatasource _datasource;

  @override
  Future<PaginatedResult<T>> fetchPage(
    int page, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _datasource.fetchPage(page, query: query);
    final meta = response.meta ?? const <String, dynamic>{};
    final items = response.data
        .map((dynamic e) => fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedResult<T>(
      items: items,
      currentPage: (meta['current_page'] as int?) ?? page,
      lastPage: (meta['last_page'] as int?) ?? page,
      total: (meta['total'] as int?) ?? items.length,
    );
  }

  @override
  Future<T> getOne(String id) async {
    final json = await _datasource.show(id);
    return fromJson(json);
  }

  @override
  Future<T> create(Map<String, dynamic> data) async {
    final json = await _datasource.create(data);
    return fromJson(json);
  }

  @override
  Future<T> update(String id, Map<String, dynamic> data) async {
    final json = await _datasource.update(id, data);
    return fromJson(json);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.delete(id);
  }

  @override
  T fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
      'GridRepositoryImpl.fromJson must be overridden in the concrete repository.',
    );
  }
}
