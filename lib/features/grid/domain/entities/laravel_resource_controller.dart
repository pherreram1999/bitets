class LaravelResourceController {
  const LaravelResourceController(this.basePath);

  final String basePath;

  String list({int? page}) => page == null ? basePath : '$basePath?page=$page';

  String show(String id) => '$basePath/$id';
  String create() => basePath;
  String update(String id) => '$basePath/$id';
  String delete(String id) => '$basePath/$id';
}
