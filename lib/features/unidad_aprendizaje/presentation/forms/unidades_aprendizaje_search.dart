import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../carrera/presentation/providers/carrera_providers.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../../plan_estudio/presentation/providers/plan_estudio_providers.dart';
import '../../domain/entities/unidad_aprendizaje.dart';

class UnidadesAprendizajeSearch extends GridSearch<UnidadAprendizaje> {
  const UnidadesAprendizajeSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar unidades de aprendizaje';

  @override
  ConsumerState<GridSearch<UnidadAprendizaje>> createState() =>
      _UnidadesAprendizajeSearchState();
}

class _UnidadesAprendizajeSearchState
    extends GridSearchState<UnidadAprendizaje> {
  final _nombreController = TextEditingController();
  final _semestreController = TextEditingController();
  int? _carreraId;
  int? _planEstudioId;

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _nombreController.text = (values['nombre'] as String?) ?? '';
    _semestreController.text = _asText(values['semestre']);
    _carreraId = _asInt(values['carrera_id']);
    _planEstudioId = _asInt(values['plan_estudio_id']);
  }

  String _asText(dynamic value) => switch (value) {
    int n => n.toString(),
    String s => s,
    _ => '',
  };

  int? _asInt(dynamic value) => switch (value) {
    int n => n,
    String s => int.tryParse(s),
    _ => null,
  };

  @override
  void resetSearchFields() {
    _nombreController.clear();
    _semestreController.clear();
    setState(() {
      _carreraId = null;
      _planEstudioId = null;
    });
  }

  @override
  Widget buildSearchFields(BuildContext context) {
    final carrerasAsync = ref.watch(carrerasListProvider);
    final planesAsync = ref.watch(planesEstudioListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nombreController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => submit(),
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _semestreController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => submit(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Semestre (1-12)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.numbers),
          ),
        ),
        const SizedBox(height: 12),
        carrerasAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar carreras: $e'),
          data: (carreras) => DropdownButtonFormField<int>(
            initialValue: _carreraId,
            decoration: const InputDecoration(
              labelText: 'Carrera',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todas')),
              ...carreras.map(
                (c) => DropdownMenuItem<int>(
                  value: int.parse(c.id),
                  child: Text(c.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _carreraId = value),
          ),
        ),
        const SizedBox(height: 12),
        planesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar planes: $e'),
          data: (planes) => DropdownButtonFormField<int>(
            initialValue: _planEstudioId,
            decoration: const InputDecoration(
              labelText: 'Plan de estudio',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todos')),
              ...planes.map(
                (p) => DropdownMenuItem<int>(
                  value: int.parse(p.id),
                  child: Text(p.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _planEstudioId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {
      'nombre': _nombreController.text,
      'semestre': _semestreController.text.trim().isEmpty
          ? null
          : int.tryParse(_semestreController.text.trim()),
      'carrera_id': _carreraId,
      'plan_estudio_id': _planEstudioId,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _semestreController.dispose();
    super.dispose();
  }
}
