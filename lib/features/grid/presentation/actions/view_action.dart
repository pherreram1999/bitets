import 'package:flutter/material.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/repositories/grid_repository.dart';

class ViewAction<T extends HasId> extends GridAction<T> {
  const ViewAction();

  @override
  String get label => 'Visualizar';

  @override
  IconData get icon => Icons.visibility_outlined;

  @override
  Future<bool> execute(
    BuildContext context,
    T? item,
    GridRepository<T> repository,
    LaravelResourceController controller,
    GridFormBuilder<T> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('ViewAction requires a non-null item.');
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => formBuilder(
          endpoint: controller.show(item.id),
          item: item,
          readOnly: true,
        ),
      ),
    );
    return result ?? false;
  }
}
