import 'package:flutter/material.dart';
import 'has_id.dart';
import 'laravel_resource_controller.dart';
import '../repositories/grid_repository.dart';

typedef GridFormBuilder<T> =
    Widget Function({required String endpoint, T? item, bool readOnly});

abstract class GridAction<T extends HasId> {
  const GridAction();

  String get label;
  IconData get icon;
  bool get requiresConfirmation => false;
  String? get confirmationMessage => null;

  Future<bool> execute(
    BuildContext context,
    T? item,
    GridRepository<T> repository,
    LaravelResourceController controller,
    GridFormBuilder<T> formBuilder,
  );
}
