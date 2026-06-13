import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../edificio/presentation/providers/edificio_providers.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../domain/entities/salon.dart';

class SalonesSearch extends GridSearch<Salon> {
  const SalonesSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar salones';

  @override
  ConsumerState<GridSearch<Salon>> createState() => _SalonesSearchState();
}

class _SalonesSearchState extends GridSearchState<Salon> {
  final _nombreController = TextEditingController();
  int? _edificioId;

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _nombreController.text = (values['nombre'] as String?) ?? '';
    _edificioId = _asInt(values['edificio_id']);
  }

  int? _asInt(dynamic value) => switch (value) {
    int n => n,
    String s => int.tryParse(s),
    _ => null,
  };

  @override
  void resetSearchFields() {
    _nombreController.clear();
    setState(() => _edificioId = null);
  }

  @override
  Widget buildSearchFields(BuildContext context) {
    final edificiosAsync = ref.watch(edificiosListProvider);
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
        edificiosAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar edificios: $e'),
          data: (edificios) => DropdownButtonFormField<int>(
            initialValue: _edificioId,
            decoration: const InputDecoration(
              labelText: 'Edificio',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todos')),
              ...edificios.map(
                (e) => DropdownMenuItem<int>(
                  value: int.parse(e.id),
                  child: Text(e.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _edificioId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {'nombre': _nombreController.text, 'edificio_id': _edificioId};
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
