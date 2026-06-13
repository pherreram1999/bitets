import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../domain/entities/plan_estudio.dart';

class PlanesEstudioSearch extends GridSearch<PlanEstudio> {
  const PlanesEstudioSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar planes de estudio';

  @override
  ConsumerState<GridSearch<PlanEstudio>> createState() =>
      _PlanesEstudioSearchState();
}

class _PlanesEstudioSearchState extends GridSearchState<PlanEstudio> {
  static final DateTime _firstDate = DateTime(2000, 1, 1);
  static final DateTime _lastDate = DateTime(2100, 12, 31);

  final _nombreController = TextEditingController();
  final _inicialDesdeController = TextEditingController();
  final _inicialHastaController = TextEditingController();
  final _finalDesdeController = TextEditingController();
  final _finalHastaController = TextEditingController();

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _nombreController.text = (values['nombre'] as String?) ?? '';
    _inicialDesdeController.text =
        _formatDateOnly(values['periodo_inicial_desde']) ?? '';
    _inicialHastaController.text =
        _formatDateOnly(values['periodo_inicial_hasta']) ?? '';
    _finalDesdeController.text =
        _formatDateOnly(values['periodo_final_desde']) ?? '';
    _finalHastaController.text =
        _formatDateOnly(values['periodo_final_hasta']) ?? '';
  }

  String? _formatDateOnly(dynamic raw) {
    if (raw is DateTime) {
      return '${raw.year.toString().padLeft(4, '0')}-${raw.month.toString().padLeft(2, '0')}-${raw.day.toString().padLeft(2, '0')}';
    }
    if (raw is String && raw.isNotEmpty) {
      return raw.length >= 10 ? raw.substring(0, 10) : raw;
    }
    return null;
  }

  @override
  void resetSearchFields() {
    _nombreController.clear();
    _inicialDesdeController.clear();
    _inicialHastaController.clear();
    _finalDesdeController.clear();
    _finalHastaController.clear();
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
        _DateField(
          controller: _inicialDesdeController,
          label: 'Periodo inicial desde',
          firstDate: _firstDate,
          lastDate: _lastDate,
        ),
        const SizedBox(height: 12),
        _DateField(
          controller: _inicialHastaController,
          label: 'Periodo inicial hasta',
          firstDate: _firstDate,
          lastDate: _lastDate,
        ),
        const SizedBox(height: 12),
        _DateField(
          controller: _finalDesdeController,
          label: 'Periodo final desde',
          firstDate: _firstDate,
          lastDate: _lastDate,
        ),
        const SizedBox(height: 12),
        _DateField(
          controller: _finalHastaController,
          label: 'Periodo final hasta',
          firstDate: _firstDate,
          lastDate: _lastDate,
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {
      'nombre': _nombreController.text,
      'periodo_inicial_desde': _dateTimeOrNull(_inicialDesdeController.text),
      'periodo_inicial_hasta': _dateTimeOrNull(_inicialHastaController.text),
      'periodo_final_desde': _dateTimeOrNull(_finalDesdeController.text),
      'periodo_final_hasta': _dateTimeOrNull(_finalHastaController.text),
    };
  }

  DateTime? _dateTimeOrNull(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return DateTime.tryParse(trimmed);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _inicialDesdeController.dispose();
    _inicialHastaController.dispose();
    _finalDesdeController.dispose();
    _finalHastaController.dispose();
    super.dispose();
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.label,
    required this.firstDate,
    required this.lastDate,
  });

  final TextEditingController controller;
  final String label;
  final DateTime firstDate;
  final DateTime lastDate;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(controller.text) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      controller.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _pick(context),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Limpiar',
          onPressed: () => controller.clear(),
        ),
      ),
    );
  }
}
