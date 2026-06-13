import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../domain/entities/edificio.dart';

class EdificiosSearch extends GridSearch<Edificio> {
  const EdificiosSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar edificios';

  @override
  ConsumerState<GridSearch<Edificio>> createState() => _EdificiosSearchState();
}

class _EdificiosSearchState extends GridSearchState<Edificio> {
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
