import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/charts_repository_impl.dart';
import '../../domain/entities/chart_data.dart';
import '../../domain/repositories/charts_repository.dart';

part 'charts_providers.g.dart';

final chartsRepositoryProvider = Provider<ChartsRepository>(
  (ref) => ChartsRepositoryImpl(),
);

@riverpod
Future<ChartData> examenesPorCarrera(Ref ref) {
  return ref.read(chartsRepositoryProvider).getExamenesPorCarrera();
}

@riverpod
Future<ChartData> inscritosPorMateria(Ref ref) {
  return ref.read(chartsRepositoryProvider).getInscritosPorMateria();
}
