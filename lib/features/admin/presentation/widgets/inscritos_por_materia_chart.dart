import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chart_data.dart';
import '../providers/charts_providers.dart';
import 'chart_palette.dart';
import 'chart_states.dart';

class InscritosPorMateriaChart extends ConsumerWidget {
  const InscritosPorMateriaChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(inscritosPorMateriaProvider);

    return ChartCard(
      title: 'Inscritos por unidad de aprendizaje',
      subtitle: 'Alumnos inscritos agrupados por materia (examenes activos)',
      icon: Icons.bar_chart_outlined,
      child: asyncData.when(
        data: (data) => _BarChartBody(data: data),
        loading: () => const ChartLoading(height: 260),
        error: (e, _) => ChartError(message: e.toString()),
      ),
    );
  }
}

class _BarChartBody extends StatelessWidget {
  const _BarChartBody({required this.data});

  final ChartData data;

  static const int _maxBars = 12;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (data.isEmpty || data.total == 0) {
      return const ChartEmpty(height: 220);
    }

    final pairs = <_LabeledValue>[];
    for (var i = 0; i < data.labels.length; i++) {
      final v = i < data.values.length ? data.values[i] : 0;
      if (v > 0) {
        pairs.add(_LabeledValue(data.labels[i], v));
      }
    }
    pairs.sort((a, b) => b.value.compareTo(a.value));
    final truncated = pairs.take(_maxBars).toList();

    if (truncated.isEmpty) {
      return const ChartEmpty(height: 220);
    }

    final maxValue = truncated.first.value;
    final maxValueDouble = maxValue.toDouble();
    final primary = chartPalette(colorScheme).first;
    final groupCount = truncated.length;
    final chartHeight = (groupCount * 36.0 + 60).clamp(180.0, 360.0);

    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < truncated.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: truncated[i].value.toDouble(),
              color: primary,
              width: 18,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: chartHeight,
          child: BarChart(
            BarChartData(
              maxY: maxValueDouble * 1.2,
              alignment: BarChartAlignment.spaceAround,
              barGroups: barGroups,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _niceInterval(maxValueDouble),
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: colorScheme.outlineVariant, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: _niceInterval(maxValueDouble),
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          value.toInt().toString(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= truncated.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Transform.rotate(
                          angle: -0.6,
                          child: SizedBox(
                            width: 80,
                            child: Text(
                              truncated[index].label,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (pairs.length > _maxBars) ...[
          const SizedBox(height: 8),
          Text(
            'Mostrando las $_maxBars materias con mas inscritos de ${pairs.length}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  double _niceInterval(double max) {
    if (max <= 0) return 1.0;
    final raw = max / 4;
    final magnitude = _pow10(raw.abs().toString().length - 1);
    final normalized = raw / magnitude;
    double nice;
    if (normalized < 1.5) {
      nice = 1.0;
    } else if (normalized < 3) {
      nice = 2.0;
    } else if (normalized < 7) {
      nice = 5.0;
    } else {
      nice = 10.0;
    }
    return nice * magnitude;
  }

  double _pow10(int exp) {
    var v = 1.0;
    for (var i = 0; i < exp; i++) {
      v *= 10;
    }
    return v;
  }
}

class _LabeledValue {
  const _LabeledValue(this.label, this.value);

  final String label;
  final int value;
}
