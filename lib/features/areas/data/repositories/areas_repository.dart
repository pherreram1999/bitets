import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/area.dart';

class AreasRepository extends GridRepositoryImpl<Area> {
  AreasRepository()
    : super(controller: const LaravelResourceController('/areas'));

  @override
  Area fromJson(Map<String, dynamic> json) => Area.fromJson(json);
}
