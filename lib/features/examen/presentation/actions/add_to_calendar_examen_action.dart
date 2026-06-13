import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../domain/entities/examen.dart';
import '../services/calendar_export.dart';

class AddToCalendarExamenAction extends GridAction<Examen> {
  const AddToCalendarExamenAction();

  @override
  String get label => 'Añadir a calendario';

  @override
  IconData get icon => Icons.event_note_outlined;

  @override
  Future<bool> execute(
    BuildContext context,
    Examen? item,
    GridRepository<Examen> repository,
    LaravelResourceController controller,
    GridFormBuilder<Examen> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError(
        'AddToCalendarExamenAction requires a non-null item.',
      );
    }
    final result = await downloadAndShareCalendarFile(
      context: context,
      endpoint: ApiConstants.misExamenesIcalExamen(int.parse(item.id)),
      filename: 'examen-${item.id}.ics',
      mimeType: 'text/calendar',
      label: 'Examen ${item.descripcion}',
    );
    return result.success;
  }
}
