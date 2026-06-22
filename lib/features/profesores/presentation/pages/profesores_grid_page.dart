import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../areas/presentation/providers/areas_providers.dart';
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
import '../../data/repositories/profesores_repository.dart';
import '../../domain/entities/profesor.dart';
import '../forms/profesor_form.dart';
import '../forms/profesores_search.dart';
import '../providers/profesores_providers.dart';

class ProfesoresGridPage extends GridPage<Profesor> {
  const ProfesoresGridPage({super.key});

  @override
  String get title => 'Profesores';

  @override
  GridRepository<Profesor> get repository => ProfesoresRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/profesores');

  @override
  List<GridAction<Profesor>> get actions => const [
    ViewAction<Profesor>(),
    EditAction<Profesor>(),
    DeleteAction<Profesor>(),
  ];

  @override
  GridAction<Profesor>? get createAction => const CreateAction<Profesor>();

  @override
  GridFormBuilder<Profesor> get formBuilder =>
      ({required String endpoint, Profesor? item, bool readOnly = false}) =>
          ProfesorForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(profesoresFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(profesoresFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<Profesor> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<Profesor>> searchKey,
  ) => ProfesoresSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<Profesor>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(profesoresGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(profesoresGridProvider);
    ref.invalidate(areasListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(profesoresGridProvider);
    await ref.read(profesoresGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Profesor item) {
    return Consumer(
      builder: (context, ref, _) {
        final areasAsync = ref.watch(areasListProvider);
        final areaNombre = areasAsync.maybeWhen(
          data: (areas) {
            for (final a in areas) {
              if (int.tryParse(a.id) == item.areaId) return a.nombre;
            }
            return null;
          },
          orElse: () => null,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.nombre, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              item.email,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (areaNombre != null) ...[
              const SizedBox(height: 2),
              Text(
                areaNombre,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
