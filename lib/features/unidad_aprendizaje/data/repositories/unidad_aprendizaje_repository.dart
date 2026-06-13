import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/unidad_aprendizaje.dart';

class UnidadAprendizajeRepository
    extends GridRepositoryImpl<UnidadAprendizaje> {
  UnidadAprendizajeRepository()
    : super(
        controller: const LaravelResourceController('/unidades-aprendizaje'),
      );

  @override
  UnidadAprendizaje fromJson(Map<String, dynamic> json) =>
      UnidadAprendizaje.fromJson(json);
}
