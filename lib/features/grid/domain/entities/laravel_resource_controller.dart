class LaravelResourceController {
  const LaravelResourceController(this.basePath);

  final String basePath;

  String list({int? page, Map<String, dynamic>? query}) {
    final params = <String, String>{};
    if (page != null) params['page'] = page.toString();
    if (query != null) {
      query.forEach((key, value) {
        if (value == null) return;
        if (value is String && value.isEmpty) return;
        params[key] = value.toString();
      });
    }
    if (params.isEmpty) return basePath;
    final encoded = params.entries
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
    return '$basePath?$encoded';
  }

  String show(String id) => '$basePath/$id';
  String create() => basePath;
  String update(String id) => '$basePath/$id';
  String delete(String id) => '$basePath/$id';
  String attach(String id) => '$basePath/$id';
}
