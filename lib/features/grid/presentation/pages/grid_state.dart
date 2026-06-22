import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/user_role.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../domain/entities/grid_action.dart';
import '../../domain/entities/has_id.dart';
import '../../domain/entities/paginated_result.dart';
import 'grid_page.dart';
import 'grid_search_modal.dart';

class GridState<T extends HasId> extends ConsumerState<GridPage<T>> {
  int _currentPage = 1;

  bool _isAdmin(WidgetRef ref) {
    final auth = ref.read(authProvider);
    return auth.maybeWhen(
      authenticated: (user) => user.isAdmin,
      orElse: () => false,
    );
  }

  List<GridAction<T>> _visibleActions(WidgetRef ref, T item) {
    final admin = _isAdmin(ref);
    return widget.actions
        .where((a) => !a.requiresAdmin || admin)
        .where((a) => a.isVisibleForItem(ref, item))
        .toList(growable: false);
  }

  Future<bool> _confirmAction(GridAction<T> action) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(action.label),
        content: Text(action.confirmationMessage ?? '¿Estas seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(action.label),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _runAction(GridAction<T> action, T? item) async {
    if (action.requiresConfirmation && !await _confirmAction(action)) {
      return;
    }
    if (!mounted) return;

    final shouldRefresh = await action.execute(
      context,
      item,
      widget.repository,
      widget.controller,
      widget.formBuilder,
    );

    if (!mounted) return;
    if (shouldRefresh) {
      widget.onActionCompleted(ref);
    }
  }

  Future<void> _openCreate() async {
    final create = widget.createAction;
    if (create == null) return;
    await _runAction(create, null);
  }

  Future<void> _openSearch() async {
    final currentFilters = widget.currentFilters(ref);
    final result = await showGridSearch<T>(
      context: context,
      searchBuilder: (key) => widget.buildSearch(context, currentFilters, key),
    );
    if (!mounted) return;
    if (result == null) return;
    widget.updateFilters(ref, result);
    if (_currentPage != 1) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

  void _goToPage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  Widget? _buildSearchAction() {
    final filters = widget.currentFilters(ref);
    final hasFilters = filters.isNotEmpty;
    return IconButton(
      icon: Badge(
        isLabelVisible: hasFilters,
        label: Text('${filters.length}'),
        child: const Icon(Icons.search),
      ),
      tooltip: hasFilters ? 'Buscar (filtros activos)' : 'Buscar',
      onPressed: _openSearch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gridState = widget.watchGrid(ref, _currentPage);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ?_buildSearchAction(),
          ...widget.extraAppBarActions(context, ref),
          if (widget.createAction != null && _isAdmin(ref))
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Crear',
              onPressed: _openCreate,
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: gridState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Error al cargar: $error',
                style: TextStyle(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (PaginatedResult<T> result) {
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => widget.refresh(ref, _currentPage),
                    child: result.items.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 200),
                            children: const [
                              Center(child: Text('Sin resultados')),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: result.items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = result.items[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: widget.buildCardBody(
                                          context,
                                          item,
                                        ),
                                      ),
                                      PopupMenuButton<GridAction<T>>(
                                        icon: const Icon(Icons.more_vert),
                                        tooltip: 'Acciones',
                                        onSelected: (GridAction<T> action) =>
                                            _runAction(action, item),
                                        itemBuilder: (context) =>
                                            _visibleActions(ref, item)
                                                .map(
                                                  (GridAction<T> a) =>
                                                      PopupMenuItem<
                                                        GridAction<T>
                                                      >(
                                                        value: a,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              a.icon,
                                                              size: 20,
                                                            ),
                                                            const SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(a.label),
                                                          ],
                                                        ),
                                                      ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                _PaginationBar(
                  currentPage: result.currentPage,
                  lastPage: result.lastPage,
                  total: result.total,
                  onPageChanged: _goToPage,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.onPageChanged,
  });

  final int currentPage;
  final int lastPage;
  final int total;
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    final hasPrev = currentPage > 1;
    final hasNext = currentPage < lastPage;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total: $total', style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              IconButton(
                onPressed: hasPrev
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Pagina anterior',
              ),
              Text('Pagina $currentPage de $lastPage'),
              IconButton(
                onPressed: hasNext
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Pagina siguiente',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
