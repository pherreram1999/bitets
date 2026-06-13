import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/examen.dart';

class AlumnoExamenRepository extends GridRepositoryImpl<Examen> {
  AlumnoExamenRepository()
    : super(controller: const LaravelResourceController('/mis-examenes'));

  @override
  Examen fromJson(Map<String, dynamic> json) => Examen.fromJson(json);
}
