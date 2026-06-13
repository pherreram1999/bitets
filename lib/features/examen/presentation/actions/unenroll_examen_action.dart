import 'package:flutter/material.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../domain/entities/examen.dart';

class UnenrollExamenAction extends GridAction<Examen> {
  const UnenrollExamenAction();

  @override
  String get label => 'Desinscribir';

  @override
  IconData get icon => Icons.event_busy_outlined;

  @override
  bool get requiresConfirmation => true;

  @override
  String? get confirmationMessage => '¿Desinscribirte de este examen?';

  @override
  Future<bool> execute(
    BuildContext context,
    Examen? item,
    GridRepository<Examen> repository,
    LaravelResourceController controller,
    GridFormBuilder<Examen> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('UnenrollExamenAction requires a non-null item.');
    }
    await repository.delete(item.id);
    return true;
  }
}
