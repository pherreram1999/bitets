import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../../grid/presentation/pages/grid_page.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../data/repositories/examen_repository.dart';
import '../../domain/entities/examen.dart';
import '../actions/enroll_examen_action.dart';
import '../actions/view_examen_details_action.dart';
import '../forms/examenes_search.dart';
import '../providers/examen_providers.dart';
import 'alumno_examenes_grid_page.dart' show ExamenStatusChip;

class AlumnoCatalogoExamenesGridPage extends GridPage<Examen> {
  const AlumnoCatalogoExamenesGridPage({super.key});

  @override
  String get title => 'Examenes disponibles';

  @override
  GridRepository<Examen> get repository => ExamenRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/examenes');

  @override
  List<GridAction<Examen>> get actions => const [
    ViewExamenDetailsAction(),
    EnrollExamenAction(),
  ];

  @override
  GridFormBuilder<Examen> get formBuilder =>
      ({required String endpoint, Examen? item, bool readOnly = false}) =>
          throw UnimplementedError(
            'AlumnoCatalogoExamenesGridPage does not support forms.',
          );

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(alumnoCatalogoExamenesFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(alumnoCatalogoExamenesFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<Examen> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<Examen>> searchKey,
  ) => ExamenesSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<Examen>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(alumnoCatalogoExamenesGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(alumnoCatalogoExamenesGridProvider);
    ref.invalidate(enrolledExamenIdsProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(alumnoCatalogoExamenesGridProvider);
    ref.invalidate(enrolledExamenIdsProvider);
    await ref.read(alumnoCatalogoExamenesGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Examen item) {
    final colorScheme = Theme.of(context).colorScheme;
    final unidad = item.unidadAprendizaje;
    final profesor = item.profesor;
    final salon = item.salon;
    final edificio = salon?.edificio;
    final semestre = unidad?.semestre;

    return Consumer(
      builder: (context, ref, _) {
        final enrolledIds = ref.watch(enrolledExamenIdsProvider).asData?.value;
        final enrolled = enrolledIds?.contains(item.id) ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    item.descripcion,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (enrolled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Inscrito',
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  ExamenStatusChip(active: item.activo),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(item.horario),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (semestre != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '· Semestre $semestre',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            if (unidad != null) ...[
              const SizedBox(height: 2),
              Text(
                unidad.nombre,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
            ],
            if (profesor != null || salon != null) ...[
              const SizedBox(height: 2),
              Text(
                [
                  profesor?.nombre,
                  if (edificio != null) edificio.nombre,
                  salon?.nombre,
                ].whereType<String>().join(' · '),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
