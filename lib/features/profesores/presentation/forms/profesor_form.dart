import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../areas/presentation/providers/areas_providers.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../domain/entities/profesor.dart';

class ProfesorForm extends GridForm<Profesor> {
  const ProfesorForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<Profesor>> createState() => _ProfesorFormState();
}

class _ProfesorFormState extends GridFormState<Profesor> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  int? _areaId;

  @override
  String get formTitle =>
      widget.item == null ? 'Nuevo profesor' : 'Editar profesor';

  @override
  void hydrate(Profesor? item) {
    _nombreController.text = item?.nombre ?? '';
    _emailController.text = item?.email ?? '';
    _areaId = item?.areaId;
  }

  @override
  Widget buildFormFields(BuildContext context, Profesor? item) {
    final areasAsync = ref.watch(areasListProvider);

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
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        areasAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar areas: $e'),
          data: (areas) => DropdownButtonFormField<int>(
            initialValue: _areaId,
            decoration: const InputDecoration(
              labelText: 'Area',
              border: OutlineInputBorder(),
            ),
            items: areas
                .map(
                  (a) => DropdownMenuItem<int>(
                    value: int.parse(a.id),
                    child: Text(a.nombre),
                  ),
                )
                .toList(),
            onChanged: widget.readOnly
                ? null
                : (value) => setState(() => _areaId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    final email = _emailController.text.trim();
    if (widget.item == null) {
      return {'nombre': nombre, 'email': email, 'area_id': _areaId};
    }
    return {
      if (nombre.isNotEmpty) 'nombre': nombre,
      if (email.isNotEmpty) 'email': email,
      if (_areaId != null) 'area_id': _areaId,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
