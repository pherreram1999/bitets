import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'auth_interceptor.dart';

/// Singleton que provee la instancia de Dio configurada.
class DioClient {
  DioClient._();

  static final Dio instance = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.timeout,
        receiveTimeout: ApiConstants.timeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Log de peticiones solo en debug
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }

  /// Registra el interceptor de autenticacion.
  /// Debe llamarse una vez configurado el callback onUnauthorized.
  static void addAuthInterceptor(AuthInterceptor interceptor) {
    instance.interceptors.add(interceptor);
  }
}
