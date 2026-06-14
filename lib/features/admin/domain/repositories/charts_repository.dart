import '../../domain/entities/chart_data.dart';

abstract class ChartsRepository {
  Future<ChartData> getExamenesPorCarrera();

  Future<ChartData> getInscritosPorMateria();
}
