import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../grid/presentation/pages/grid_search.dart';
import '../../../grid/presentation/pages/grid_search_state.dart';
import '../../../profesores/presentation/forms/profesores_async_search.dart';
import '../../../salon/presentation/forms/salones_async_search.dart';
import '../../../unidad_aprendizaje/presentation/forms/unidades_aprendizaje_async_search.dart';
import '../../domain/entities/examen.dart';
import '../widgets/async_picker_field.dart';

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
  String? _unidadAprendizajeNombre;
  int? _unidadAprendizajeCarreraId;
  int? _unidadAprendizajePlanEstudioId;

  int? _profesorId;
  String? _profesorNombre;

  int? _salonId;
  String? _salonNombre;

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
      _unidadAprendizajeNombre = null;
      _unidadAprendizajeCarreraId = null;
      _unidadAprendizajePlanEstudioId = null;
      _profesorId = null;
      _profesorNombre = null;
      _salonId = null;
      _salonNombre = null;
    });
  }

  Future<void> _pickUnidad() async {
    final selected = await UnidadesAprendizajeAsyncSearchModal.show(
      context,
      initialCarreraId: _unidadAprendizajeCarreraId,
      initialPlanEstudioId: _unidadAprendizajePlanEstudioId,
    );
    if (selected == null || !mounted) return;
    setState(() {
      _unidadAprendizajeId = int.parse(selected.id);
      _unidadAprendizajeNombre = selected.nombre;
      _unidadAprendizajeCarreraId = selected.carreraId;
      _unidadAprendizajePlanEstudioId = selected.planEstudioId;
    });
  }

  void _clearUnidad() {
    setState(() {
      _unidadAprendizajeId = null;
      _unidadAprendizajeNombre = null;
      _unidadAprendizajeCarreraId = null;
      _unidadAprendizajePlanEstudioId = null;
    });
  }

  Future<void> _pickProfesor() async {
    final selected = await ProfesoresAsyncSearchModal.show(context);
    if (selected == null || !mounted) return;
    setState(() {
      _profesorId = int.parse(selected.id);
      _profesorNombre = selected.nombre;
    });
  }

  void _clearProfesor() {
    setState(() {
      _profesorId = null;
      _profesorNombre = null;
    });
  }

  Future<void> _pickSalon() async {
    final selected = await SalonesAsyncSearchModal.show(context);
    if (selected == null || !mounted) return;
    setState(() {
      _salonId = int.parse(selected.id);
      _salonNombre = selected.nombre;
    });
  }

  void _clearSalon() {
    setState(() {
      _salonId = null;
      _salonNombre = null;
    });
  }

  @override
  Widget buildSearchFields(BuildContext context) {
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
        AsyncPickerField(
          label: 'Unidad de aprendizaje',
          icon: Icons.school_outlined,
          value: _unidadAprendizajeNombre,
          enabled: true,
          onTap: _pickUnidad,
          onClear: _unidadAprendizajeId == null ? null : _clearUnidad,
        ),
        const SizedBox(height: 12),
        AsyncPickerField(
          label: 'Profesor',
          icon: Icons.person_outline,
          value: _profesorNombre,
          enabled: true,
          onTap: _pickProfesor,
          onClear: _profesorId == null ? null : _clearProfesor,
        ),
        const SizedBox(height: 12),
        AsyncPickerField(
          label: 'Salon',
          icon: Icons.meeting_room_outlined,
          value: _salonNombre,
          enabled: true,
          onTap: _pickSalon,
          onClear: _salonId == null ? null : _clearSalon,
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
