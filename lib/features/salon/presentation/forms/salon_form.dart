import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../edificio/presentation/providers/edificio_providers.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../domain/entities/salon.dart';

class SalonForm extends GridForm<Salon> {
  const SalonForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<Salon>> createState() => _SalonFormState();
}

class _SalonFormState extends GridFormState<Salon> {
  final _nombreController = TextEditingController();
  int? _edificioId;

  @override
  String get formTitle => widget.item == null ? 'Nuevo salon' : 'Editar salon';

  @override
  void hydrate(Salon? item) {
    _nombreController.text = item?.nombre ?? '';
    _edificioId = item?.edificioId;
  }

  @override
  Widget buildFormFields(BuildContext context, Salon? item) {
    final edificiosAsync = ref.watch(edificiosListProvider);

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
        edificiosAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar edificios: $e'),
          data: (edificios) => DropdownButtonFormField<int>(
            initialValue: _edificioId,
            decoration: const InputDecoration(
              labelText: 'Edificio',
              border: OutlineInputBorder(),
            ),
            items: edificios
                .map(
                  (e) => DropdownMenuItem<int>(
                    value: int.parse(e.id),
                    child: Text(e.nombre),
                  ),
                )
                .toList(),
            onChanged: widget.readOnly
                ? null
                : (value) => setState(() => _edificioId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    if (widget.item == null) {
      return {'nombre': nombre, 'edificio_id': _edificioId};
    }
    return {
      if (nombre.isNotEmpty) 'nombre': nombre,
      if (_edificioId != null) 'edificio_id': _edificioId,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
