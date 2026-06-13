import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/edificio.dart';

class EdificioRepository extends GridRepositoryImpl<Edificio> {
  EdificioRepository()
    : super(controller: const LaravelResourceController('/edificios'));

  @override
  Edificio fromJson(Map<String, dynamic> json) => Edificio.fromJson(json);
}
