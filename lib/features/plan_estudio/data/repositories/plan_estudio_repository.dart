import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/plan_estudio.dart';

class PlanEstudioRepository extends GridRepositoryImpl<PlanEstudio> {
  PlanEstudioRepository()
    : super(controller: const LaravelResourceController('/planes-estudio'));

  @override
  PlanEstudio fromJson(Map<String, dynamic> json) => PlanEstudio.fromJson(json);
}
