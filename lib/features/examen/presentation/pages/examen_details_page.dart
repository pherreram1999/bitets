import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/examen.dart';
import '../providers/examen_providers.dart';
import '../services/calendar_export.dart';

class ExamenDetailsPage extends ConsumerStatefulWidget {
  const ExamenDetailsPage({super.key, required this.examen});

  final Examen examen;

  @override
  ConsumerState<ExamenDetailsPage> createState() => _ExamenDetailsPageState();
}

class _ExamenDetailsPageState extends ConsumerState<ExamenDetailsPage> {
  bool _busy = false;
  bool _busyIcal = false;
  String? _errorMessage;

  bool get _isEnrolled {
    final enrolled = ref.watch(enrolledExamenIdsProvider).asData?.value;
    if (enrolled == null) return false;
    return enrolled.contains(widget.examen.id);
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }

  String _extractDioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    switch (e.response?.statusCode) {
      case 401:
        return 'No autorizado.';
      case 409:
        return 'Ya estas inscrito en este examen.';
      case 500:
        return 'Error del servidor. Intenta mas tarde.';
      default:
        return 'Error de conexion. Verifica tu internet.';
    }
  }

  Future<void> _enroll() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    try {
      final dio = DioClient.instance;
      await dio.post('/mis-examenes/${widget.examen.id}');
      ref.invalidate(enrolledExamenIdsProvider);
      ref.invalidate(alumnoExamenesGridProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inscrito correctamente.')));
      setState(() {});
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _extractDioMessage(e);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo inscribir. Intenta de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _unenroll() async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Desinscribir'),
        content: const Text('¿Desinscribirte de este examen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Desinscribir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    try {
      final dio = DioClient.instance;
      await dio.delete('/mis-examenes/${widget.examen.id}');
      ref.invalidate(enrolledExamenIdsProvider);
      ref.invalidate(alumnoExamenesGridProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desinscrito correctamente.')),
      );
      setState(() {});
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _extractDioMessage(e);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo desinscribir. Intenta de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _addToCalendar() async {
    if (_busyIcal) return;
    await downloadAndShareCalendarFile(
      context: context,
      endpoint: ApiConstants.misExamenesIcalExamen(int.parse(widget.examen.id)),
      filename: 'examen-${widget.examen.id}.ics',
      mimeType: 'text/calendar',
      label: 'Examen ${widget.examen.descripcion}',
      setBusy: (v) => setState(() => _busyIcal = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final examen = widget.examen;
    final unidad = examen.unidadAprendizaje;
    final profesor = examen.profesor;
    final salon = examen.salon;
    final edificio = salon?.edificio;
    final enrolled = _isEnrolled;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del examen')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                unidad?.nombre ?? examen.descripcion,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.event,
                label: 'Horario',
                value: _formatDateTime(examen.horario),
              ),
              if (unidad != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.school_outlined,
                  label: 'Unidad de aprendizaje',
                  value: [
                    unidad.nombre,
                    if (unidad.semestre != null) 'Semestre ${unidad.semestre}',
                  ].join(' · '),
                ),
              ],
              if (profesor != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.person_outline,
                  label: 'Profesor',
                  value: profesor.nombre,
                ),
              ],
              if (edificio != null || salon != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.meeting_room_outlined,
                  label: 'Ubicacion',
                  value: [
                    if (edificio != null) edificio.nombre,
                    if (salon != null) salon.nombre,
                  ].join(' · '),
                ),
              ],
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.toggle_on_outlined,
                label: 'Estado',
                value: examen.activo ? 'Activo' : 'Inactivo',
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (enrolled)
                FilledButton.tonalIcon(
                  onPressed: _busy ? null : _unenroll,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.event_busy_outlined),
                  label: const Text('Desinscribir'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: (_busy || !examen.activo) ? null : _enroll,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_circle_outline),
                  label: Text(
                    examen.activo ? 'Inscribirme' : 'Examen no disponible',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              if (enrolled) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _busyIcal ? null : _addToCalendar,
                  icon: _busyIcal
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.event_note_outlined),
                  label: const Text('Añadir a calendario'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
