import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../../grid/presentation/actions/create_action.dart';
import '../../../grid/presentation/actions/delete_action.dart';
import '../../../grid/presentation/actions/edit_action.dart';
import '../../../grid/presentation/actions/view_action.dart';
import '../../../grid/presentation/pages/grid_page.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../data/repositories/carrera_repository.dart';
import '../../domain/entities/carrera.dart';
import '../forms/carrera_form.dart';
import '../forms/carreras_search.dart';
import '../providers/carrera_providers.dart';

class CarreraGridPage extends GridPage<Carrera> {
  const CarreraGridPage({super.key});

  @override
  String get title => 'Carreras';

  @override
  GridRepository<Carrera> get repository => CarreraRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/carreras');

  @override
  List<GridAction<Carrera>> get actions => const [
    CreateAction<Carrera>(),
    ViewAction<Carrera>(),
    EditAction<Carrera>(),
    DeleteAction<Carrera>(),
  ];

  @override
  GridFormBuilder<Carrera> get formBuilder =>
      ({required String endpoint, Carrera? item, bool readOnly = false}) =>
          CarreraForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(carrerasFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(carrerasFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<Carrera> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<Carrera>> searchKey,
  ) => CarrerasSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<Carrera>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(carreraGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(carreraGridProvider);
    ref.invalidate(carrerasListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(carreraGridProvider);
    await ref.read(carreraGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Carrera item) {
    return Text(item.nombre, style: Theme.of(context).textTheme.titleMedium);
  }
}
