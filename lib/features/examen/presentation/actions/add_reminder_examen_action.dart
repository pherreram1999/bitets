import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/notifications/notifications_service.dart';
import '../../../grid/domain/entities/grid_action.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/repositories/grid_repository.dart';
import '../../domain/entities/examen.dart';

class AddReminderAction extends GridAction<Examen> {
  const AddReminderAction();

  @override
  String get label => 'Agregar recordatorio';

  @override
  IconData get icon => Icons.notifications_active_outlined;

  @override
  Future<bool> execute(
    BuildContext context,
    Examen? item,
    GridRepository<Examen> repository,
    LaravelResourceController controller,
    GridFormBuilder<Examen> formBuilder,
  ) async {
    if (item == null) {
      throw ArgumentError('AddReminderAction requires a non-null item.');
    }
    final container = ProviderScope.containerOf(context);
    final svc = container.read(notificationsServiceProvider);
    final result = await showDialog<_ReminderResult>(
      context: context,
      builder: (_) => _ReminderDialog(examen: item),
    );
    if (result == null) return false;
    final now = DateTime.now();
    if (!result.fireAt.isAfter(now)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La fecha debe ser futura y anterior al examen.'),
          ),
        );
      }
      return false;
    }
    if (result.fireAt.isAfter(item.horario)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La fecha debe ser anterior al examen.'),
          ),
        );
      }
      return false;
    }
    final idInt = int.tryParse(item.id) ?? 0;
    await svc.scheduleAt(
      examenId: idInt,
      fireAt: result.fireAt,
      title: 'Recordatorio: ${item.descripcion}',
      body: result.label,
      tipo: 'personalizada',
    );
    return true;
  }
}

class _ReminderResult {
  const _ReminderResult({required this.fireAt, required this.label});
  final DateTime fireAt;
  final String label;
}

class _ReminderDialog extends StatefulWidget {
  const _ReminderDialog({required this.examen});
  final Examen examen;

  @override
  State<_ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<_ReminderDialog> {
  late DateTime _date;
  late TimeOfDay _time;
  final _labelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final def = widget.examen.horario.subtract(const Duration(hours: 1));
    final base = def.isAfter(now) ? def : now.add(const Duration(minutes: 5));
    _date = DateTime(base.year, base.month, base.day);
    _time = TimeOfDay(hour: base.hour, minute: base.minute);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: widget.examen.horario,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fireAt = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    return AlertDialog(
      title: const Text('Recordatorio personalizado'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Examen: ${widget.examen.descripcion}'),
            const SizedBox(height: 4),
            Text(
              'Fecha del examen: ${_formatDateTime(widget.examen.horario)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _labelController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Mensaje (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final label = _labelController.text.trim().isEmpty
                ? 'Tu examen "${widget.examen.descripcion}" se aproxima.'
                : _labelController.text.trim();
            Navigator.of(
              context,
            ).pop(_ReminderResult(fireAt: fireAt, label: label));
          },
          child: const Text('Programar'),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
