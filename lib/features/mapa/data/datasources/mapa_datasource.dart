import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/mapa_canvas_response.dart';

class MapaDatasource {
  MapaDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<MapaCanvasResponse> fetchCanvas() async {
    final response = await _dio.get(ApiConstants.mapaCanvas);
    final data = response.data;
    final Map<String, dynamic> payload;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final inner = data['data'];
      payload = inner is Map<String, dynamic>
          ? inner
          : Map<String, dynamic>.from(inner as Map);
    } else if (data is Map<String, dynamic>) {
      payload = data;
    } else {
      payload = Map<String, dynamic>.from(data as Map);
    }
    return MapaCanvasResponse.fromJson(payload);
  }
}
