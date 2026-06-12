import 'package:flutter/material.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/repositories/grid_repository.dart';

class DeleteAction<T extends HasId> extends GridAction<T> {
  const DeleteAction();

  @override
  String get label => 'Eliminar';

  @override
  IconData get icon => Icons.delete_outline;

  @override
  bool get requiresConfirmation => true;

  @override
  String? get confirmationMessage => '¿Estas seguro de eliminar este elemento?';

  @override
  Future<bool> execute(
    BuildContext context,
    T? item,
    GridRepository<T> repository,
    LaravelResourceController controller,
    GridFormBuilder<T> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('DeleteAction requires a non-null item.');
    }
    await repository.delete(item.id);
    return true;
  }
}
