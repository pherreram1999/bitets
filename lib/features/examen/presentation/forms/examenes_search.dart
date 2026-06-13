import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../../profesores/presentation/providers/profesores_providers.dart';
import '../../../salon/presentation/providers/salon_providers.dart';
import '../../../unidad_aprendizaje/presentation/providers/unidad_aprendizaje_providers.dart';
import '../../domain/entities/examen.dart';

class ExamenesSearch extends GridSearch<Examen> {
  const ExamenesSearch({super.key, super.initialValues});

  @override
  String get searchTitle => 'Buscar examenes';

  @override
  ConsumerState<GridSearch<Examen>> createState() => _ExamenesSearchState();
}

class _ExamenesSearchState extends GridSearchState<Examen> {
  final _descripcionController = TextEditingController();
  DateTime? _horarioDesde;
  DateTime? _horarioHasta;
  int? _unidadAprendizajeId;
  int? _profesorId;
  int? _salonId;

  @override
  void hydrate(Map<String, dynamic>? values) {
    if (values == null) return;
    _descripcionController.text = (values['descripcion'] as String?) ?? '';
    _horarioDesde = _parseDateTime(values['horario_desde']);
    _horarioHasta = _parseDateTime(values['horario_hasta']);
    _unidadAprendizajeId = _asInt(values['unidad_aprendizaje_id']);
    _profesorId = _asInt(values['profesor_id']);
    _salonId = _asInt(values['salon_id']);
  }

  DateTime? _parseDateTime(dynamic raw) {
    if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
    if (raw is DateTime) return raw;
    return null;
  }

  int? _asInt(dynamic value) => switch (value) {
    int n => n,
    String s => int.tryParse(s),
    _ => null,
  };

  @override
  void resetSearchFields() {
    _descripcionController.clear();
    setState(() {
      _horarioDesde = null;
      _horarioHasta = null;
      _unidadAprendizajeId = null;
      _profesorId = null;
      _salonId = null;
    });
  }

  @override
  Widget buildSearchFields(BuildContext context) {
    final unidadesAsync = ref.watch(unidadesAprendizajeListProvider);
    final profesoresAsync = ref.watch(profesoresListProvider);
    final salonesAsync = ref.watch(salonesListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _descripcionController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => submit(),
          decoration: const InputDecoration(
            labelText: 'Descripcion',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        _DateTimeField(
          value: _horarioDesde,
          label: 'Horario desde',
          onChanged: (v) => setState(() => _horarioDesde = v),
        ),
        const SizedBox(height: 12),
        _DateTimeField(
          value: _horarioHasta,
          label: 'Horario hasta',
          onChanged: (v) => setState(() => _horarioHasta = v),
        ),
        const SizedBox(height: 12),
        unidadesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar unidades: $e'),
          data: (unidades) => DropdownButtonFormField<int>(
            initialValue: _unidadAprendizajeId,
            decoration: const InputDecoration(
              labelText: 'Unidad de aprendizaje',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todas')),
              ...unidades.map(
                (u) => DropdownMenuItem<int>(
                  value: int.parse(u.id),
                  child: Text(u.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _unidadAprendizajeId = value),
          ),
        ),
        const SizedBox(height: 12),
        profesoresAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar profesores: $e'),
          data: (profesores) => DropdownButtonFormField<int>(
            initialValue: _profesorId,
            decoration: const InputDecoration(
              labelText: 'Profesor',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todos')),
              ...profesores.map(
                (p) => DropdownMenuItem<int>(
                  value: int.parse(p.id),
                  child: Text(p.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _profesorId = value),
          ),
        ),
        const SizedBox(height: 12),
        salonesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (Object e, _) => Text('Error al cargar salones: $e'),
          data: (salones) => DropdownButtonFormField<int>(
            initialValue: _salonId,
            decoration: const InputDecoration(
              labelText: 'Salon',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Todos')),
              ...salones.map(
                (s) => DropdownMenuItem<int>(
                  value: int.parse(s.id),
                  child: Text(s.nombre),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _salonId = value),
          ),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectSearchValues() {
    return {
      'descripcion': _descripcionController.text,
      'horario_desde': _horarioDesde?.toIso8601String(),
      'horario_hasta': _horarioHasta?.toIso8601String(),
      'unidad_aprendizaje_id': _unidadAprendizajeId,
      'profesor_id': _profesorId,
      'salon_id': _salonId,
    };
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }
}

class _DateTimeField extends StatefulWidget {
  const _DateTimeField({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final DateTime? value;
  final String label;
  final ValueChanged<DateTime?> onChanged;

  @override
  State<_DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<_DateTimeField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value == null ? '' : _format(widget.value!),
    );
  }

  @override
  void didUpdateWidget(covariant _DateTimeField old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _controller.text = widget.value == null ? '' : _format(widget.value!);
    }
  }

  String _format(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }

  Future<void> _pick() async {
    final now = DateTime.now();
    final initial = widget.value ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    widget.onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _pick,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.event),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Limpiar',
          onPressed: () => widget.onChanged(null),
        ),
      ),
    );
  }
}
