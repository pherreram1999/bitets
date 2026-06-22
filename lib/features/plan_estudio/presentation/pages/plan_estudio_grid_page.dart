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
import '../../data/repositories/plan_estudio_repository.dart';
import '../../domain/entities/plan_estudio.dart';
import '../forms/plan_estudio_form.dart';
import '../forms/planes_estudio_search.dart';
import '../providers/plan_estudio_providers.dart';

class PlanesEstudioGridPage extends GridPage<PlanEstudio> {
  const PlanesEstudioGridPage({super.key});

  @override
  String get title => 'Planes de estudio';

  @override
  GridRepository<PlanEstudio> get repository => PlanEstudioRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/planes-estudio');

  @override
  List<GridAction<PlanEstudio>> get actions => const [
    ViewAction<PlanEstudio>(),
    EditAction<PlanEstudio>(),
    DeleteAction<PlanEstudio>(),
  ];

  @override
  GridFormBuilder<PlanEstudio> get formBuilder =>
      ({required String endpoint, PlanEstudio? item, bool readOnly = false}) =>
          PlanEstudioForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(planesEstudioFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(planesEstudioFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<PlanEstudio> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<PlanEstudio>> searchKey,
  ) => PlanesEstudioSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<PlanEstudio>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(planesEstudioGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(planesEstudioGridProvider);
    ref.invalidate(planesEstudioListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(planesEstudioGridProvider);
    await ref.read(planesEstudioGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, PlanEstudio item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.nombre, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          '${_formatDate(item.periodoInicial)}  →  ${_formatDate(item.periodoFinal)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

String _formatDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
