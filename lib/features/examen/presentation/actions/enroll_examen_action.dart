import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../domain/entities/examen.dart';
import '../providers/examen_providers.dart';

class EnrollExamenAction extends GridAction<Examen> {
  const EnrollExamenAction();

  @override
  String get label => 'Inscribirme';

  @override
  IconData get icon => Icons.add_circle_outline;

  @override
  bool get requiresConfirmation => true;

  @override
  String? get confirmationMessage => '¿Inscribirte a este examen?';

  @override
  bool isVisibleForItem(WidgetRef ref, Examen item) {
    final enrolled = ref.read(enrolledExamenIdsProvider).asData?.value;
    if (enrolled == null) return true;
    return !enrolled.contains(item.id);
  }

  @override
  Future<bool> execute(
    BuildContext context,
    Examen? item,
    GridRepository<Examen> repository,
    LaravelResourceController controller,
    GridFormBuilder<Examen> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('EnrollExamenAction requires a non-null item.');
    }
    final dio = DioClient.instance;
    await dio.post('/mis-examenes/${item.id}');
    return true;
  }
}
