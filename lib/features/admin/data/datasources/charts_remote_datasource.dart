import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/chart_data.dart';

class ChartsRemoteDatasource {
  ChartsRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<ChartData> getExamenesPorCarrera() async {
    final response = await _dio.get(ApiConstants.chartExamenesPorCarrera);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Respuesta invalida para examenes-por-carrera',
      );
    }
    return ChartData.fromJson(data);
  }

  Future<ChartData> getInscritosPorMateria() async {
    final response = await _dio.get(ApiConstants.chartInscritosPorMateria);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Respuesta invalida para inscritos-por-materia',
      );
    }
    return ChartData.fromJson(data);
  }
}
