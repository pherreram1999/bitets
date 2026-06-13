import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../edificio/presentation/forms/edificios_async_search.dart';
import '../../../grid/presentation/forms/grid_form.dart';
import '../../../grid/presentation/forms/grid_form_state.dart';
import '../../../profesores/presentation/forms/profesores_async_search.dart';
import '../../../profesores/domain/entities/profesor.dart';
import '../../../profesores/presentation/providers/profesores_providers.dart';
import '../../../salon/domain/entities/salon.dart';
import '../../../salon/presentation/providers/salon_providers.dart';
import '../../../unidad_aprendizaje/domain/entities/unidad_aprendizaje.dart';
import '../../../unidad_aprendizaje/presentation/forms/unidades_aprendizaje_async_search.dart';
import '../../../unidad_aprendizaje/presentation/providers/unidad_aprendizaje_providers.dart';
import '../../domain/entities/examen.dart';
import '../widgets/async_picker_field.dart';

class ExamenForm extends GridForm<Examen> {
  const ExamenForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<Examen>> createState() => _ExamenFormState();
}

class _ExamenFormState extends GridFormState<Examen> {
  final _descripcionController = TextEditingController();
  DateTime? _horario;
  int? _userId;

  int? _edificioId;
  String? _edificioNombre;
  int? _salonId;

  int? _unidadAprendizajeId;
  String? _unidadAprendizajeNombre;
  int? _unidadAprendizajeSemestre;
  int? _unidadAprendizajeCarreraId;
  int? _unidadAprendizajePlanEstudioId;

  int? _profesorId;
  String? _profesorNombre;

  @override
  String get formTitle => widget.item == null
      ? 'Nuevo examen'
      : (widget.readOnly ? 'Detalle del examen' : 'Editar examen');

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _hydrateFromLists(item);
    }
  }

  @override
  void hydrate(Examen? item) {
    if (item != null) {
      _descripcionController.text = item.descripcion;
      _horario = item.horario;
      _userId = item.userId;
      _unidadAprendizajeId = item.unidadAprendizajeId;
      _profesorId = item.profesorId;
      _salonId = item.salonId;

      final unidad = item.unidadAprendizaje;
      _unidadAprendizajeNombre = unidad?.nombre;
      _unidadAprendizajeSemestre = unidad?.semestre;
      _unidadAprendizajeCarreraId = unidad?.carreraId;
      _unidadAprendizajePlanEstudioId = unidad?.planEstudioId;

      _profesorNombre = item.profesor?.nombre;
      _edificioId = item.salon?.edificioId;
      _edificioNombre = item.salon?.edificio?.nombre;
    } else {
      final auth = ref.read(authProvider);
      _userId = auth.maybeWhen(orElse: () => null, authenticated: (u) => u.id);
    }
  }

  Future<void> _hydrateFromLists(Examen item) async {
    final futures = <Future<Object?>>[
      if (item.unidadAprendizajeId > 0)
        ref.read(unidadesAprendizajeListProvider.future),
      if (item.profesorId > 0) ref.read(profesoresListProvider.future),
      if (item.salonId > 0) ref.read(salonesListProvider.future),
    ];
    if (futures.isEmpty) return;
    final results = await Future.wait(futures);
    if (!mounted) return;
    setState(() {
      int i = 0;
      if (item.unidadAprendizajeId > 0) {
        final unidades = results[i++] as List<UnidadAprendizaje>;
        for (final u in unidades) {
          if (int.tryParse(u.id) == item.unidadAprendizajeId) {
            _unidadAprendizajeNombre ??= u.nombre;
            _unidadAprendizajeSemestre ??= u.semestre;
            _unidadAprendizajeCarreraId ??= u.carreraId;
            _unidadAprendizajePlanEstudioId ??= u.planEstudioId;
            break;
          }
        }
      }
      if (item.profesorId > 0) {
        final profesores = results[i++] as List<Profesor>;
        for (final p in profesores) {
          if (int.tryParse(p.id) == item.profesorId) {
            _profesorNombre ??= p.nombre;
            break;
          }
        }
      }
      if (item.salonId > 0) {
        final salones = results[i++] as List<Salon>;
        for (final s in salones) {
          if (int.tryParse(s.id) == item.salonId) {
            _edificioId ??= s.edificioId;
            break;
          }
        }
      }
    });
  }

  Future<void> _pickEdificio() async {
    final selected = await EdificiosAsyncSearchModal.show(context);
    if (selected == null || !mounted) return;
    final newId = int.parse(selected.id);
    if (newId == _edificioId) return;
    setState(() {
      _edificioId = newId;
      _edificioNombre = selected.nombre;
      _salonId = null;
    });
  }

  void _clearEdificio() {
    setState(() {
      _edificioId = null;
      _edificioNombre = null;
      _salonId = null;
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
      _unidadAprendizajeSemestre = selected.semestre;
      _unidadAprendizajeCarreraId = selected.carreraId;
      _unidadAprendizajePlanEstudioId = selected.planEstudioId;
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

  @override
  Widget buildFormFields(BuildContext context, Examen? item) {
    final salonesAsync = ref.watch(salonesByEdificioProvider(_edificioId ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _descripcionController,
          readOnly: widget.readOnly,
          decoration: const InputDecoration(
            labelText: 'Descripcion',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        _DateTimeField(
          value: _horario,
          label: 'Horario',
          enabled: !widget.readOnly,
          onChanged: (value) => setState(() => _horario = value),
        ),
        const SizedBox(height: 16),
        AsyncPickerField(
          label: 'Edificio',
          icon: Icons.apartment_outlined,
          value: _edificioNombre,
          enabled: !widget.readOnly,
          onTap: _pickEdificio,
          onClear: _clearEdificio,
        ),
        const SizedBox(height: 16),
        _salonesField(context, salonesAsync),
        const SizedBox(height: 16),
        AsyncPickerField(
          label: 'Unidad de aprendizaje',
          icon: Icons.school_outlined,
          value: _unidadAprendizajeNombre,
          enabled: !widget.readOnly,
          onTap: _pickUnidad,
        ),
        if (_unidadAprendizajeSemestre != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Semestre $_unidadAprendizajeSemestre',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(height: 16),
        AsyncPickerField(
          label: 'Profesor',
          icon: Icons.person_outline,
          value: _profesorNombre,
          enabled: !widget.readOnly,
          onTap: _pickProfesor,
        ),
      ],
    );
  }

  Widget _salonesField(
    BuildContext context,
    AsyncValue<List<Salon>> salonesAsync,
  ) {
    if (_edificioId == null) {
      return TextField(
        enabled: false,
        decoration: const InputDecoration(
          labelText: 'Salon',
          hintText: 'Selecciona un edificio primero',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.meeting_room_outlined),
        ),
      );
    }
    return salonesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (Object e, _) => Text('Error al cargar salones: $e'),
      data: (salones) {
        if (salones.isEmpty) {
          return TextField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Salon',
              hintText: 'Sin salones para este edificio',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.meeting_room_outlined),
            ),
          );
        }
        return DropdownButtonFormField<int>(
          initialValue: _salonId,
          decoration: const InputDecoration(
            labelText: 'Salon',
            border: OutlineInputBorder(),
          ),
          items: salones
              .map(
                (Salon s) => DropdownMenuItem<int>(
                  value: int.parse(s.id),
                  child: Text(s.nombre),
                ),
              )
              .toList(),
          onChanged: widget.readOnly
              ? null
              : (value) => setState(() => _salonId = value),
        );
      },
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final descripcion = _descripcionController.text.trim();
    final horarioIso = _horario?.toIso8601String();
    if (widget.item == null) {
      return {
        'descripcion': descripcion,
        'horario': ?horarioIso,
        'user_id': _userId,
        'unidad_aprendizaje_id': _unidadAprendizajeId,
        'profesor_id': _profesorId,
        'salon_id': _salonId,
      };
    }
    return {
      if (descripcion.isNotEmpty) 'descripcion': descripcion,
      'horario': ?horarioIso,
      if (_userId != null) 'user_id': _userId,
      if (_unidadAprendizajeId != null)
        'unidad_aprendizaje_id': _unidadAprendizajeId,
      if (_profesorId != null) 'profesor_id': _profesorId,
      if (_salonId != null) 'salon_id': _salonId,
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
    required this.enabled,
    required this.onChanged,
  });

  final DateTime? value;
  final String label;
  final bool enabled;
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
      onTap: widget.enabled ? _pick : null,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.event),
        suffixIcon: widget.enabled
            ? IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Limpiar',
                onPressed: () => widget.onChanged(null),
              )
            : null,
      ),
    );
  }
}
