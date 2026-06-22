import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../edificio/presentation/providers/edificio_providers.dart';
import '../../../examen/domain/entities/examen.dart';
import '../../../salon/domain/entities/salon.dart';
import '../providers/mapa_providers.dart';

class EdificioSalonesSheet extends ConsumerWidget {
  const EdificioSalonesSheet({
    super.key,
    required this.edificioNumero,
    required this.label,
  });

  final int edificioNumero;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edificioAsync = ref.watch(edificioByNumeroProvider(edificioNumero));
    final examenesAsync = ref.watch(examenesPorEdificioNumeroProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final examenes = examenesAsync.maybeWhen(
      data: (m) => m[edificioNumero] ?? const <Examen>[],
      orElse: () => const <Examen>[],
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Salones del edificio',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            edificioAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (Object error, StackTrace _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No se pudieron cargar los salones: $error',
                    style: TextStyle(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (edificio) {
                if (edificio == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Edificio no encontrado',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }
                final salones = edificio.salones;
                if (salones.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Sin salones registrados',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: salones.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final salon = salones[index];
                      final salonIdInt = int.tryParse(salon.id);
                      final salonExamenes = salonIdInt == null
                          ? const <Examen>[]
                          : examenes
                                .where((e) => e.salonId == salonIdInt)
                                .toList();
                      return _SalonTile(
                        salon: salon,
                        examenes: salonExamenes,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonTile extends StatelessWidget {
  const _SalonTile({
    required this.salon,
    required this.examenes,
    required this.colorScheme,
    required this.textTheme,
  });

  final Salon salon;
  final List<Examen> examenes;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final hasExamenes = examenes.isNotEmpty;
    return Container(
      decoration: hasExamenes
          ? BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.meeting_room_outlined,
              color: hasExamenes ? colorScheme.onPrimaryContainer : null,
            ),
            title: Text(
              salon.nombre,
              style: TextStyle(
                color: hasExamenes ? colorScheme.onPrimaryContainer : null,
              ),
            ),
            trailing: hasExamenes
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${examenes.length}',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
          ),
          if (hasExamenes)
            Padding(
              padding: const EdgeInsets.fromLTRB(44, 0, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final e in examenes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 14,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${e.unidadAprendizaje?.nombre ?? e.descripcion} · ${_formatDateTime(e.horario)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
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
