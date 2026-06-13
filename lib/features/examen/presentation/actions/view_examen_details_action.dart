import 'package:flutter/material.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../domain/entities/examen.dart';
import '../pages/examen_details_page.dart';

class ViewExamenDetailsAction extends GridAction<Examen> {
  const ViewExamenDetailsAction();

  @override
  String get label => 'Ver detalles';

  @override
  IconData get icon => Icons.visibility_outlined;

  @override
  Future<bool> execute(
    BuildContext context,
    Examen? item,
    GridRepository<Examen> repository,
    LaravelResourceController controller,
    GridFormBuilder<Examen> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('ViewExamenDetailsAction requires a non-null item.');
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => ExamenDetailsPage(examen: item)),
    );
    return false;
  }
}
