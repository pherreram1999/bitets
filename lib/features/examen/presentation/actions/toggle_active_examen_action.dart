import 'package:flutter/material.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../domain/entities/examen.dart';

class ToggleActiveExamenAction extends GridAction<Examen> {
  const ToggleActiveExamenAction();

  @override
  String get label => 'Activar / Desactivar';

  @override
  IconData get icon => Icons.power_settings_new;

  @override
  bool get requiresConfirmation => true;

  @override
  String? get confirmationMessage =>
      '¿Cambiar el estado activo de este examen?';

  @override
  bool get requiresAdmin => true;

  @override
  Future<bool> execute(
    BuildContext context,
    Examen? item,
    GridRepository<Examen> repository,
    LaravelResourceController controller,
    GridFormBuilder<Examen> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('ToggleActiveExamenAction requires a non-null item.');
    }
    await repository.update(item.id, {'activo': !item.activo});
    return true;
  }
}
