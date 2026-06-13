import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/salon.dart';

class SalonRepository extends GridRepositoryImpl<Salon> {
  SalonRepository()
    : super(controller: const LaravelResourceController('/salones'));

  @override
  Salon fromJson(Map<String, dynamic> json) => Salon.fromJson(json);
}
