import 'package:flutter/material.dart';
import '../../domain/entities/has_id.dart';
import 'grid_search.dart';
import 'grid_search_state.dart';

Future<Map<String, dynamic>?> showGridSearch<T extends HasId>({
  required BuildContext context,
  required GridSearch<T> Function(GlobalKey<GridSearchState<T>>) searchBuilder,
}) {
  final searchKey = GlobalKey<GridSearchState<T>>();
  final search = searchBuilder(searchKey);
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) =>
        _GridSearchModal<T>(search: search, searchKey: searchKey),
  );
}

class _GridSearchModal<T extends HasId> extends StatelessWidget {
  const _GridSearchModal({required this.search, required this.searchKey});

  final GridSearch<T> search;
  final GlobalKey<GridSearchState<T>> searchKey;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(search.searchTitle),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                searchKey.currentState?.resetSearchFields();
                Navigator.of(context).pop(<String, dynamic>{});
              },
              child: const Text('Limpiar'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: search,
      ),
    );
  }
}
