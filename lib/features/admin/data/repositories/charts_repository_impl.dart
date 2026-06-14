import '../../domain/entities/chart_data.dart';
import '../../domain/repositories/charts_repository.dart';
import '../datasources/charts_remote_datasource.dart';

class ChartsRepositoryImpl implements ChartsRepository {
  ChartsRepositoryImpl({ChartsRemoteDatasource? remote})
    : _remote = remote ?? ChartsRemoteDatasource();

  final ChartsRemoteDatasource _remote;

  @override
  Future<ChartData> getExamenesPorCarrera() => _remote.getExamenesPorCarrera();

  @override
  Future<ChartData> getInscritosPorMateria() =>
      _remote.getInscritosPorMateria();
}
