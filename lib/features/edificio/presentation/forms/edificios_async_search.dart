import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/edificio.dart';
import '../providers/edificio_providers.dart';

class EdificiosAsyncSearchModal extends ConsumerStatefulWidget {
  const EdificiosAsyncSearchModal({super.key, this.initialQuery});

  final String? initialQuery;

  static Future<Edificio?> show(BuildContext context, {String? initialQuery}) {
    return showDialog<Edificio>(
      context: context,
      barrierDismissible: true,
      builder: (_) => EdificiosAsyncSearchModal(initialQuery: initialQuery),
    );
  }

  @override
  ConsumerState<EdificiosAsyncSearchModal> createState() =>
      _EdificiosAsyncSearchModalState();
}

class _EdificiosAsyncSearchModalState
    extends ConsumerState<EdificiosAsyncSearchModal> {
  late final TextEditingController _searchController;
  Timer? _debounce;
  String _debouncedQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _debouncedQuery = widget.initialQuery ?? '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _debouncedQuery = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final edificiosAsync = ref.watch(edificiosDatasetProvider(_debouncedQuery));
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buscar edificio'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Buscar edificio...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Limpiar',
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          ),
                  ),
                ),
              ),
              Expanded(
                child: edificiosAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (Object e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error al cargar edificios: $e',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ),
                  data: (edificios) {
                    if (edificios.isEmpty) {
                      return Center(
                        child: Text(
                          _debouncedQuery.isEmpty
                              ? 'Sin resultados'
                              : 'Sin coincidencias para "$_debouncedQuery"',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: edificios.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final e = edificios[index];
                        return ListTile(
                          title: Text(e.nombre),
                          onTap: () => Navigator.of(context).pop(e),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
