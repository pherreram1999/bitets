import 'package:flutter/material.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/repositories/grid_repository.dart';

class CreateAction<T extends HasId> extends GridAction<T> {
  const CreateAction();

  @override
  String get label => 'Crear';

  @override
  IconData get icon => Icons.add;

  @override
  Future<bool> execute(
    BuildContext context,
    T? item,
    GridRepository<T> repository,
    LaravelResourceController controller,
    GridFormBuilder<T> formBuilder,
  ) async {
    if (item != null) {
      throw ArgumentError('CreateAction requires item to be null.');
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => formBuilder(
          endpoint: controller.create(),
          item: null,
          readOnly: false,
        ),
      ),
    );
    return result ?? false;
  }
}
