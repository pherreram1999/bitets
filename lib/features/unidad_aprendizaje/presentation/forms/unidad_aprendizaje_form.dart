import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../carrera/presentation/providers/carrera_providers.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../../plan_estudio/presentation/providers/plan_estudio_providers.dart';
import '../../domain/entities/unidad_aprendizaje.dart';

class UnidadAprendizajeForm extends GridForm<UnidadAprendizaje> {
  const UnidadAprendizajeForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<UnidadAprendizaje>> createState() =>
      _UnidadAprendizajeFormState();
}

class _UnidadAprendizajeFormState extends GridFormState<UnidadAprendizaje> {
  final _nombreController = TextEditingController();
  final _semestreController = TextEditingController();
  int? _carreraId;
  int? _planEstudioId;

  @override
  String get formTitle => widget.item == null
      ? 'Nueva unidad de aprendizaje'
      : 'Editar unidad de aprendizaje';

  @override
  void hydrate(UnidadAprendizaje? item) {
    _nombreController.text = item?.nombre ?? '';
    _semestreController.text = item?.semestre?.toString() ?? '';
    _carreraId = item?.carreraId;
    _planEstudioId = item?.planEstudioId;
  }

  @override
  Widget buildFormFields(BuildContext context, UnidadAprendizaje? item) {
    final carrerasAsync = ref.watch(carrerasListProvider);
    final planesAsync = ref.watch(planesEstudioListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nombreController,
          readOnly: widget.readOnly,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _semestreController,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Semestre (opcional, 1-12)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        carrerasAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar carreras: $e'),
          data: (carreras) => DropdownButtonFormField<int>(
            initialValue: _carreraId,
            decoration: const InputDecoration(
              labelText: 'Carrera',
              border: OutlineInputBorder(),
            ),
            items: carreras
                .map(
                  (c) => DropdownMenuItem<int>(
                    value: int.parse(c.id),
                    child: Text(c.nombre),
                  ),
                )
                .toList(),
            onChanged: widget.readOnly
                ? null
                : (value) => setState(() => _carreraId = value),
          ),
        ),
        const SizedBox(height: 16),
        planesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar planes de estudio: $e'),
          data: (planes) => DropdownButtonFormField<int>(
            initialValue: _planEstudioId,
            decoration: const InputDecoration(
              labelText: 'Plan de estudio',
              border: OutlineInputBorder(),
            ),
            items: planes
                .map(
                  (p) => DropdownMenuItem<int>(
                    value: int.parse(p.id),
                    child: Text(p.nombre),
                  ),
                )
                .toList(),
            onChanged: widget.readOnly
                ? null
                : (value) => setState(() => _planEstudioId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    final semestreRaw = _semestreController.text.trim();
    final semestre = semestreRaw.isEmpty ? null : int.tryParse(semestreRaw);
    if (widget.item == null) {
      return {
        'nombre': nombre,
        'carrera_id': _carreraId,
        'plan_estudio_id': _planEstudioId,
        'semestre': ?semestre,
      };
    }
    return {
      if (nombre.isNotEmpty) 'nombre': nombre,
      if (_carreraId != null) 'carrera_id': _carreraId,
      if (_planEstudioId != null) 'plan_estudio_id': _planEstudioId,
      'semestre': semestre,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _semestreController.dispose();
    super.dispose();
  }
}
