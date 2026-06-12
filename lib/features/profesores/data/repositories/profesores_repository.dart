import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/profesor.dart';

class ProfesoresRepository extends GridRepositoryImpl<Profesor> {
  ProfesoresRepository()
    : super(controller: const LaravelResourceController('/profesores'));

  @override
  Profesor fromJson(Map<String, dynamic> json) => Profesor.fromJson(json);
}
