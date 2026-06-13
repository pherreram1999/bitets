import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../domain/entities/carrera.dart';

class CarrerasSearch extends GridSearch<Carrera> {
  const CarrerasSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar carreras';

  @override
  ConsumerState<GridSearch<Carrera>> createState() => _CarrerasSearchState();
}

class _CarrerasSearchState extends GridSearchState<Carrera> {
  final _nombreController = TextEditingController();

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _nombreController.text = (values['nombre'] as String?) ?? '';
  }

  @override
  void resetSearchFields() {
    _nombreController.clear();
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
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {'nombre': _nombreController.text};
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
