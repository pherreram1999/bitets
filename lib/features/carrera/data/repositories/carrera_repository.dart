import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/carrera.dart';

class CarreraRepository extends GridRepositoryImpl<Carrera> {
  CarreraRepository()
    : super(controller: const LaravelResourceController('/carreras'));

  @override
  Carrera fromJson(Map<String, dynamic> json) => Carrera.fromJson(json);
}
