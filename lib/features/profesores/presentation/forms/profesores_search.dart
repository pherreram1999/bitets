import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../areas/presentation/providers/areas_providers.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../domain/entities/profesor.dart';

class ProfesoresSearch extends GridSearch<Profesor> {
  const ProfesoresSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar profesores';

  @override
  ConsumerState<GridSearch<Profesor>> createState() => _ProfesoresSearchState();
}

class _ProfesoresSearchState extends GridSearchState<Profesor> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  int? _areaId;

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _nombreController.text = (values['nombre'] as String?) ?? '';
    _emailController.text = (values['email'] as String?) ?? '';
    _areaId = _asInt(values['area_id']);
  }

  int? _asInt(dynamic value) => switch (value) {
    int n => n,
    String s => int.tryParse(s),
    _ => null,
  };

  @override
  void resetSearchFields() {
    _nombreController.clear();
    _emailController.clear();
    setState(() => _areaId = null);
  }

  @override
  Widget buildSearchFields(BuildContext context) {
    final areasAsync = ref.watch(areasListProvider);
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
          controller: _emailController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => submit(),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 12),
        areasAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar areas: $e'),
          data: (areas) => DropdownButtonFormField<int>(
            initialValue: _areaId,
            decoration: const InputDecoration(
              labelText: 'Area',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todas')),
              ...areas.map(
                (a) => DropdownMenuItem<int>(
                  value: int.parse(a.id),
                  child: Text(a.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _areaId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {
      'nombre': _nombreController.text,
      'email': _emailController.text,
      'area_id': _areaId,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
