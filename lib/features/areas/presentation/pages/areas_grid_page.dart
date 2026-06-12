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
import '../../data/repositories/areas_repository.dart';
import '../../domain/entities/area.dart';
import '../forms/area_form.dart';
import '../providers/areas_providers.dart';

class AreasGridPage extends GridPage<Area> {
  const AreasGridPage({super.key});

  @override
  String get title => 'Areas';

  @override
  GridRepository<Area> get repository => AreasRepository();

  @override
  LaravelResourceController get controller =>
      const LaravelResourceController('/areas');

  @override
  List<GridAction<Area>> get actions => const [
    CreateAction<Area>(),
    ViewAction<Area>(),
    EditAction<Area>(),
    DeleteAction<Area>(),
  ];

  @override
  GridFormBuilder<Area> get formBuilder =>
      ({required String endpoint, Area? item, bool readOnly = false}) =>
          AreaForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override
  AsyncValue<PaginatedResult<Area>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(areasGridProvider(page));

  @override
  void onActionCompleted(WidgetRef ref) {
    ref.invalidate(areasGridProvider);
    ref.invalidate(areasListProvider);
  }

  @override
  Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(areasGridProvider);
    await ref.read(areasGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Area item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.nombre, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          item.clave,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (item.observaciones != null && item.observaciones!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            item.observaciones!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
