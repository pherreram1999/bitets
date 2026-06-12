import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../domain/entities/area.dart';

class AreaForm extends GridForm<Area> {
  const AreaForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<Area>> createState() => _AreaFormState();
}

class _AreaFormState extends GridFormState<Area> {
  final _nombreController = TextEditingController();
  final _claveController = TextEditingController();
  final _observacionesController = TextEditingController();

  @override
  String get formTitle => widget.item == null ? 'Nueva area' : 'Editar area';

  @override
  void hydrate(Area? item) {
    _nombreController.text = item?.nombre ?? '';
    _claveController.text = item?.clave ?? '';
    _observacionesController.text = item?.observaciones ?? '';
  }

  @override
  Widget buildFormFields(BuildContext context, Area? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _claveController,
          decoration: const InputDecoration(
            labelText: 'Clave',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _observacionesController,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    final clave = _claveController.text.trim();
    final observaciones = _observacionesController.text.trim();
    if (widget.item == null) {
      return {
        'nombre': nombre,
        'clave': clave,
        if (observaciones.isNotEmpty) 'observaciones': observaciones,
      };
    }
    return {
      if (nombre.isNotEmpty) 'nombre': nombre,
      if (clave.isNotEmpty) 'clave': clave,
      if (observaciones.isNotEmpty) 'observaciones': observaciones,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _claveController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
