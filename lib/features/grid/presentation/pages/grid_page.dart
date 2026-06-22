import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/grid_repository.dart';
import 'grid_search.dart';
import 'grid_search_state.dart';
import 'grid_state.dart';

abstract class GridPage<T extends HasId> extends ConsumerStatefulWidget {
  const GridPage({super.key});

  String get title;
  GridRepository<T> get repository;
  LaravelResourceController get controller;
  List<GridAction<T>> get actions;
  GridAction<T>? get createAction => null;
  GridFormBuilder<T> get formBuilder;
  GridSearch<T> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<T>> searchKey,
  );

  Map<String, dynamic> currentFilters(WidgetRef ref);
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters);

  AsyncValue<PaginatedResult<T>> watchGrid(WidgetRef ref, int page);
  void onActionCompleted(WidgetRef ref);
  Future<void> refresh(WidgetRef ref, int page);
  Widget buildCardBody(BuildContext context, T item);

  List<Widget> extraAppBarActions(BuildContext context, WidgetRef ref) =>
      const <Widget>[];

  @override
  ConsumerState<GridPage<T>> createState() => GridState<T>();
}
