import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../domain/entities/area.dart';

class AreasSearch extends GridSearch<Area> {
  const AreasSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar areas';

  @override
  ConsumerState<GridSearch<Area>> createState() => _AreasSearchState();
}

class _AreasSearchState extends GridSearchState<Area> {
  final _nombreController = TextEditingController();
  final _claveController = TextEditingController();
  final _observacionesController = TextEditingController();

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _nombreController.text = (values['nombre'] as String?) ?? '';
    _claveController.text = (values['clave'] as String?) ?? '';
    _observacionesController.text = (values['observaciones'] as String?) ?? '';
  }

  @override
  void resetSearchFields() {
    _nombreController.clear();
    _claveController.clear();
    _observacionesController.clear();
  }

  @override
  Widget buildSearchFields(BuildContext context) {
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
          controller: _claveController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => submit(),
          decoration: const InputDecoration(
            labelText: 'Clave',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.tag),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _observacionesController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => submit(),
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {
      'nombre': _nombreController.text,
      'clave': _claveController.text,
      'observaciones': _observacionesController.text,
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
