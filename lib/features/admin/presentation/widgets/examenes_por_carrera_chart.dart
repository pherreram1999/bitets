import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chart_data.dart';
import '../providers/charts_providers.dart';
import 'chart_palette.dart';
import 'chart_states.dart';

class ExamenesPorCarreraChart extends ConsumerWidget {
  const ExamenesPorCarreraChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(examenesPorCarreraProvider);

    return ChartCard(
      title: 'Examenes activos por carrera',
      subtitle: 'Distribucion de examenes vigentes agrupados por carrera',
      icon: Icons.pie_chart_outline,
      child: asyncData.when(
        data: (data) => _PieChartBody(data: data),
        loading: () => const ChartLoading(height: 220),
        error: (e, _) => ChartError(message: e.toString()),
      ),
    );
  }
}

class _PieChartBody extends StatelessWidget {
  const _PieChartBody({required this.data});

  final ChartData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (data.isEmpty || data.total == 0) {
      return const ChartEmpty(height: 220);
    }

    final palette = chartPalette(colorScheme);
    final total = data.total.toDouble();
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < data.labels.length; i++) {
      final value = i < data.values.length ? data.values[i] : 0;
      if (value <= 0) continue;
      final color = colorAt(palette, sections.length);
      sections.add(
        PieChartSectionData(
          value: value.toDouble(),
          color: color,
          title: '${((value / total) * 100).round()}%',
          titleStyle: textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
          radius: 70,
          titlePositionPercentageOffset: 0.6,
        ),
      );
    }

    if (sections.isEmpty) {
      return const ChartEmpty(height: 220);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 48,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _Legend(labels: data.labels, values: data.values, palette: palette),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.labels,
    required this.values,
    required this.palette,
  });

  final List<String> labels;
  final List<int> values;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (var i = 0; i < labels.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colorAt(palette, i),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${labels[i]} (${i < values.length ? values[i] : 0})',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
