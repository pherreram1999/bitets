import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/examenes_local_datasource.dart';
import '../../../../core/network/dio_client.dart';

class ExamenesSyncService {
  ExamenesSyncService({required ExamenesLocalDatasource local})
    : _local = local {
    _connectivitySub = Connectivity().onConnectivityChanged.listen(_onChange);
  }

  final ExamenesLocalDatasource _local;
  final Dio _dio = DioClient.instance;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _syncing = false;
  bool _hasConnection = false;
  Future<void> _onChange(List<ConnectivityResult> results) async {
    final online = !results.contains(ConnectivityResult.none);
    if (online && !_hasConnection) {
      _hasConnection = true;
      await syncPendingDeletes();
    } else {
      _hasConnection = online;
    }
  }

  Future<void> checkAndSync() async {
    final results = await Connectivity().checkConnectivity();
    final online = !results.contains(ConnectivityResult.none);
    _hasConnection = online;
    if (online) {
      await syncPendingDeletes();
    }
  }

  Future<void> syncPendingDeletes() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final pending = await _local.getPendingDeletes();
      if (pending.isEmpty) return;

      for (final row in pending) {
        try {
          await _dio.delete('/mis-examenes/${row.id}');
          await _local.removeRow(row.id);
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) {
            await _local.removeRow(row.id);
            continue;
          }
          if (kDebugMode) {
            debugPrint('sync delete failed for ${row.id}: ${e.message}');
          }
          break;
        } catch (e) {
          if (kDebugMode) {
            debugPrint('sync delete unexpected error for ${row.id}: $e');
          }
          break;
        }
      }
    } finally {
      _syncing = false;
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}
