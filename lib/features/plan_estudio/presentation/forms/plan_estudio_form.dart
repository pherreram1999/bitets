import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../domain/entities/plan_estudio.dart';

class PlanEstudioForm extends GridForm<PlanEstudio> {
  const PlanEstudioForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<PlanEstudio>> createState() => _PlanEstudioFormState();
}

class _PlanEstudioFormState extends GridFormState<PlanEstudio> {
  final _nombreController = TextEditingController();
  final _periodoInicialController = TextEditingController();
  final _periodoFinalController = TextEditingController();
  DateTime? _periodoInicial;
  DateTime? _periodoFinal;

  static final DateTime _firstDate = DateTime(2000, 1, 1);
  static final DateTime _lastDate = DateTime(2100, 12, 31);

  @override
  String get formTitle =>
      widget.item == null ? 'Nuevo plan de estudio' : 'Editar plan de estudio';

  @override
  void hydrate(PlanEstudio? item) {
    _nombreController.text = item?.nombre ?? '';
    _periodoInicial = item?.periodoInicial;
    _periodoFinal = item?.periodoFinal;
    _periodoInicialController.text = _formatDate(_periodoInicial);
    _periodoFinalController.text = _formatDate(_periodoFinal);
  }

  Future<void> _pickPeriodo(bool isInicial) async {
    if (widget.readOnly) return;
    final initial =
        (isInicial ? _periodoInicial : _periodoFinal) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null) {
      setState(() {
        if (isInicial) {
          _periodoInicial = picked;
          _periodoInicialController.text = _formatDate(picked);
        } else {
          _periodoFinal = picked;
          _periodoFinalController.text = _formatDate(picked);
        }
      });
    }
  }

  @override
  Widget buildFormFields(BuildContext context, PlanEstudio? item) {
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
        TextField(
          controller: _periodoInicialController,
          readOnly: true,
          onTap: () => _pickPeriodo(true),
          decoration: const InputDecoration(
            labelText: 'Periodo inicial',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _periodoFinalController,
          readOnly: true,
          onTap: () => _pickPeriodo(false),
          decoration: const InputDecoration(
            labelText: 'Periodo final',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    final inicialIso = _periodoInicial?.toIso8601String();
    final finalIso = _periodoFinal?.toIso8601String();
    if (widget.item == null) {
      return {
        'nombre': nombre,
        'periodo_inicial': inicialIso,
        'periodo_final': finalIso,
      };
    }
    return {
      if (nombre.isNotEmpty) 'nombre': nombre,
      'periodo_inicial': ?inicialIso,
      'periodo_final': ?finalIso,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _periodoInicialController.dispose();
    _periodoFinalController.dispose();
    super.dispose();
  }
}

String _formatDate(DateTime? d) {
  if (d == null) return '';
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
