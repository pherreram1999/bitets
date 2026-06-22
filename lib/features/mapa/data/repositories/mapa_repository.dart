import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/mapa_local_datasource.dart';
import '../../domain/entities/mapa_canvas_response.dart';
import '../datasources/mapa_datasource.dart';

class MapaRepository {
  MapaRepository({required MapaLocalDatasource local, MapaDatasource? remote})
    : _local = local,
      _remote = remote ?? MapaDatasource();

  final MapaLocalDatasource _local;
  final MapaDatasource _remote;

  Future<MapaCanvasResponse> fetchCanvas() async {
    final isOnline = await _hasConnection();
    if (isOnline) {
      try {
        final response = await _remote.fetchCanvas();
        await _local.save(response);
        return response;
      } on DioException catch (e) {
        if (kDebugMode) {
          debugPrint('MapaRepository online fetch failed: ${e.message}');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('MapaRepository online fetch unexpected: $e');
        }
      }
    }
    final cached = await _local.get();
    if (cached != null) return cached;
    throw StateError(
      'Sin conexion y sin mapa cacheado. Conectate a internet al menos una vez para descargar el mapa.',
    );
  }

  Future<bool> isOffline() async => !(await _hasConnection());

  Future<DateTime?> lastCachedAt() => _local.cachedAt();

  Future<bool> _hasConnection() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
