import 'package:flutter/material.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/repositories/grid_repository.dart';

class EditAction<T extends HasId> extends GridAction<T> {
  const EditAction();

  @override
  String get label => 'Editar';

  @override
  IconData get icon => Icons.edit_outlined;

  @override
  Future<bool> execute(
    BuildContext context,
    T? item,
    GridRepository<T> repository,
    LaravelResourceController controller,
    GridFormBuilder<T> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('EditAction requires a non-null item.');
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => formBuilder(
          endpoint: controller.update(item.id),
          item: item,
          readOnly: false,
        ),
      ),
    );
    return result ?? false;
  }
}
