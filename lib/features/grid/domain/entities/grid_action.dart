import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool get requiresAdmin => false;

  bool isVisibleForItem(WidgetRef ref, T item) => true;

  Future<bool> execute(
    BuildContext context,
    T? item,
    GridRepository<T> repository,
    LaravelResourceController controller,
    GridFormBuilder<T> formBuilder,
  );
}
