import '../entities/has_id.dart';
import '../entities/paginated_result.dart';

abstract class GridRepository<T extends HasId> {
  Future<PaginatedResult<T>> fetchPage(int page, {Map<String, dynamic>? query});
  Future<T> getOne(String id);
  Future<T> create(Map<String, dynamic> data);
  Future<T> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
  T fromJson(Map<String, dynamic> json);
}
