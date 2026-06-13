import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../domain/entities/carrera.dart';

class CarreraForm extends GridForm<Carrera> {
  const CarreraForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<Carrera>> createState() => _CarreraFormState();
}

class _CarreraFormState extends GridFormState<Carrera> {
  final _nombreController = TextEditingController();

  @override
  String get formTitle =>
      widget.item == null ? 'Nueva carrera' : 'Editar carrera';

  @override
  void hydrate(Carrera? item) {
    _nombreController.text = item?.nombre ?? '';
  }

  @override
  Widget buildFormFields(BuildContext context, Carrera? item) {
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
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    if (widget.item == null) {
      return {'nombre': nombre};
    }
    return {if (nombre.isNotEmpty) 'nombre': nombre};
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
