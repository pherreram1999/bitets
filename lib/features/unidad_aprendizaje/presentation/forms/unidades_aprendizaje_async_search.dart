import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../carrera/domain/entities/carrera.dart';
import '../../../carrera/presentation/providers/carrera_providers.dart';
import '../../../plan_estudio/domain/entities/plan_estudio.dart';
import '../../../plan_estudio/presentation/providers/plan_estudio_providers.dart';
import '../../domain/entities/unidad_aprendizaje.dart';
import '../providers/unidad_aprendizaje_providers.dart';

class UnidadesAprendizajeAsyncSearchModal extends ConsumerStatefulWidget {
  const UnidadesAprendizajeAsyncSearchModal({
    super.key,
    this.initialCarreraId,
    this.initialPlanEstudioId,
    this.initialQuery,
  });

  final int? initialCarreraId;
  final int? initialPlanEstudioId;
  final String? initialQuery;

  static Future<UnidadAprendizaje?> show(
    BuildContext context, {
    int? initialCarreraId,
    int? initialPlanEstudioId,
    String? initialQuery,
  }) {
    return showDialog<UnidadAprendizaje>(
      context: context,
      barrierDismissible: true,
      builder: (_) => UnidadesAprendizajeAsyncSearchModal(
        initialCarreraId: initialCarreraId,
        initialPlanEstudioId: initialPlanEstudioId,
        initialQuery: initialQuery,
      ),
    );
  }

  @override
  ConsumerState<UnidadesAprendizajeAsyncSearchModal> createState() =>
      _UnidadesAprendizajeAsyncSearchModalState();
}

class _UnidadesAprendizajeAsyncSearchModalState
    extends ConsumerState<UnidadesAprendizajeAsyncSearchModal> {
  late final TextEditingController _searchController;
  Timer? _debounce;
  int? _carreraId;
  int? _planEstudioId;
  String _debouncedQuery = '';

  @override
  void initState() {
    super.initState();
    _carreraId = widget.initialCarreraId;
    _planEstudioId = widget.initialPlanEstudioId;
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
    final colorScheme = Theme.of(context).colorScheme;
    final carrerasAsync = ref.watch(carrerasListProvider);
    final planesAsync = ref.watch(planesEstudioListProvider);
    final ready = (_carreraId ?? 0) != 0 && (_planEstudioId ?? 0) != 0;
    final unidadesAsync = ready
        ? ref.watch(
            unidadesAprendizajeDatasetProvider((
              carreraId: _carreraId!,
              planEstudioId: _planEstudioId!,
              query: _debouncedQuery,
            )),
          )
        : const AsyncValue<List<UnidadAprendizaje>>.data(<UnidadAprendizaje>[]);

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buscar unidad de aprendizaje'),
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
                child: Column(
                  children: [
                    carrerasAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (Object e, _) => Text(
                        'Error al cargar carreras: $e',
                        style: TextStyle(color: colorScheme.error),
                      ),
                      data: (carreras) => DropdownButtonFormField<int>(
                        initialValue: _carreraId,
                        decoration: const InputDecoration(
                          labelText: 'Carrera',
                          border: OutlineInputBorder(),
                        ),
                        items: carreras
                            .map(
                              (Carrera c) => DropdownMenuItem<int>(
                                value: int.parse(c.id),
                                child: Text(c.nombre),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() {
                          _carreraId = value;
                          _planEstudioId = null;
                        }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    planesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (Object e, _) => Text(
                        'Error al cargar planes: $e',
                        style: TextStyle(color: colorScheme.error),
                      ),
                      data: (planes) => DropdownButtonFormField<int>(
                        initialValue: _planEstudioId,
                        decoration: const InputDecoration(
                          labelText: 'Plan de estudio',
                          border: OutlineInputBorder(),
                        ),
                        items: planes
                            .map(
                              (PlanEstudio p) => DropdownMenuItem<int>(
                                value: int.parse(p.id),
                                child: Text(p.nombre),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _planEstudioId = value),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  controller: _searchController,
                  enabled: ready,
                  textInputAction: TextInputAction.search,
                  onChanged: ready ? _onSearchChanged : null,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Filtrar por nombre...',
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
                child: !ready
                    ? Center(
                        child: Text(
                          'Selecciona carrera y plan de estudio',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : unidadesAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (Object e, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Error al cargar unidades: $e',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                        ),
                        data: (unidades) {
                          if (unidades.isEmpty) {
                            return Center(
                              child: Text(
                                _debouncedQuery.isEmpty
                                    ? 'Sin resultados'
                                    : 'Sin coincidencias para "$_debouncedQuery"',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: unidades.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final u = unidades[index];
                              return ListTile(
                                title: Text(u.nombre),
                                subtitle: u.semestre != null
                                    ? Text(
                                        'Semestre ${u.semestre}',
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      )
                                    : null,
                                onTap: () => Navigator.of(context).pop(u),
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
