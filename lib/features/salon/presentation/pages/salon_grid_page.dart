import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../edificio/presentation/providers/edificio_providers.dart';
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
import '../../data/repositories/salon_repository.dart';
import '../../domain/entities/salon.dart';
import '../forms/salon_form.dart';
import '../forms/salones_search.dart';
import '../providers/salon_providers.dart';

class SalonesGridPage extends GridPage<Salon> {
  const SalonesGridPage({super.key});

  @override
  String get title => 'Salones';

  @override
  GridRepository<Salon> get repository => SalonRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/salones');

  @override
  List<GridAction<Salon>> get actions => const [
    ViewAction<Salon>(),
    EditAction<Salon>(),
    DeleteAction<Salon>(),
  ];

  @override
  GridFormBuilder<Salon> get formBuilder =>
      ({required String endpoint, Salon? item, bool readOnly = false}) =>
          SalonForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override
  Map<String, dynamic> currentFilters(WidgetRef ref) =>
      ref.watch(salonesFiltersProvider);

  @override
  void updateFilters(WidgetRef ref, Map<String, dynamic> filters) {
    ref.read(salonesFiltersProvider.notifier).apply(filters);
  }

  @override
  GridSearch<Salon> buildSearch(
    BuildContext context,
    Map<String, dynamic> currentFilters,
    GlobalKey<GridSearchState<Salon>> searchKey,
  ) => SalonesSearch(key: searchKey, initialValues: currentFilters);

  @override
  AsyncValue<PaginatedResult<Salon>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(salonesGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(salonesGridProvider);
    ref.invalidate(edificiosListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(salonesGridProvider);
    await ref.read(salonesGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Salon item) {
    return Consumer(
      builder: (context, ref, _) {
        final edificiosAsync = ref.watch(edificiosListProvider);

        final edificioNombre = edificiosAsync.maybeWhen(
          data: (edificios) {
            for (final e in edificios) {
              if (int.tryParse(e.id) == item.edificioId) return e.nombre;
            }
            return null;
          },
          orElse: () => null,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.nombre, style: Theme.of(context).textTheme.titleMedium),
            if (edificioNombre != null) ...[
              const SizedBox(height: 4),
              Text(
                edificioNombre,
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
