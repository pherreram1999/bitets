import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../../grid/presentation/actions/delete_action.dart';
import '../../../grid/presentation/actions/edit_action.dart';
import '../../../grid/presentation/actions/view_action.dart';
import '../../../grid/presentation/pages/grid_page.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../data/repositories/edificio_repository.dart';
import '../../domain/entities/edificio.dart';
import '../forms/edificio_form.dart';
import '../forms/edificios_search.dart';
import '../providers/edificio_providers.dart';

class EdificiosGridPage extends GridPage<Edificio> {
  const EdificiosGridPage({super.key});

  @override
  String get title => 'Edificios';

  @override
  GridRepository<Edificio> get repository => EdificioRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/edificios');

  @override
  List<GridAction<Edificio>> get actions => const [
    ViewAction<Edificio>(),
    EditAction<Edificio>(),
    DeleteAction<Edificio>(),
  ];

  @override
  GridFormBuilder<Edificio> get formBuilder =>
      ({required String endpoint, Edificio? item, bool readOnly = false}) =>
          EdificioForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(edificiosFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(edificiosFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<Edificio> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<Edificio>> searchKey,
  ) => EdificiosSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<Edificio>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(edificiosGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(edificiosGridProvider);
    ref.invalidate(edificiosListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(edificiosGridProvider);
    await ref.read(edificiosGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Edificio item) {
    return Text(item.nombre, style: Theme.of(context).textTheme.titleMedium);
  }
}
