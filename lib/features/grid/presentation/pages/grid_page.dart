import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/grid_repository.dart';
import 'grid_state.dart';

abstract class GridPage<T extends HasId> extends ConsumerStatefulWidget {
  const GridPage({super.key});

  String get title;
  GridRepository<T> get repository;
  LaravelResourceController get controller;
  List<GridAction<T>> get actions;
  GridFormBuilder<T> get formBuilder;

  AsyncValue<PaginatedResult<T>> watchGrid(WidgetRef ref, int page);
  void onActionCompleted(WidgetRef ref);
  Future<void> refresh(WidgetRef ref, int page);
  Widget buildCardBody(BuildContext context, T item);

  @override
  ConsumerState<GridPage<T>> createState() => GridState<T>();
}
