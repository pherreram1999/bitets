import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../carrera/presentation/providers/carrera_providers.dart';
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
import '../../../plan_estudio/presentation/providers/plan_estudio_providers.dart';
import '../../data/repositories/unidad_aprendizaje_repository.dart';
import '../../domain/entities/unidad_aprendizaje.dart';
import '../forms/unidad_aprendizaje_form.dart';
import '../forms/unidades_aprendizaje_search.dart';
import '../providers/unidad_aprendizaje_providers.dart';

class UnidadesAprendizajeGridPage extends GridPage<UnidadAprendizaje> {
  const UnidadesAprendizajeGridPage({super.key});

  @override
  String get title => 'Unidades de aprendizaje';

  @override
  GridRepository<UnidadAprendizaje> get repository =>
      UnidadAprendizajeRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/unidades-aprendizaje');

  @override
  List<GridAction<UnidadAprendizaje>> get actions => const [
    ViewAction<UnidadAprendizaje>(),
    EditAction<UnidadAprendizaje>(),
    DeleteAction<UnidadAprendizaje>(),
  ];

  @override
  GridFormBuilder<UnidadAprendizaje> get formBuilder =>
      ({
        required String endpoint,
        UnidadAprendizaje? item,
        bool readOnly = false,
      }) => UnidadAprendizajeForm(
        endpoint: endpoint,
        item: item,
        readOnly: readOnly,
      );

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(unidadesAprendizajeFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(unidadesAprendizajeFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<UnidadAprendizaje> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<UnidadAprendizaje>> searchKey,
  ) => UnidadesAprendizajeSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<UnidadAprendizaje>> watchGrid(
    WidgetRef ref,
    int page,
  ) => ref.watch(unidadesAprendizajeGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(unidadesAprendizajeGridProvider);
    ref.invalidate(carrerasListProvider);
    ref.invalidate(planesEstudioListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(unidadesAprendizajeGridProvider);
    await ref.read(unidadesAprendizajeGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, UnidadAprendizaje item) {
    return Consumer(
      builder: (context, ref, _) {
        final carrerasAsync = ref.watch(carrerasListProvider);
        final planesAsync = ref.watch(planesEstudioListProvider);

        final carreraNombre = carrerasAsync.maybeWhen(
          data: (carreras) {
            for (final c in carreras) {
              if (int.tryParse(c.id) == item.carreraId) return c.nombre;
            }
            return null;
          },
          orElse: () => null,
        );

        final planNombre = planesAsync.maybeWhen(
          data: (planes) {
            for (final p in planes) {
              if (int.tryParse(p.id) == item.planEstudioId) return p.nombre;
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
              item.semestre == null
                  ? 'Sin semestre'
                  : 'Semestre ${item.semestre}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (carreraNombre != null) ...[
              const SizedBox(height: 2),
              Text(
                carreraNombre,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
            if (planNombre != null) ...[
              const SizedBox(height: 2),
              Text(
                planNombre,
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
