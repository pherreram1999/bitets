import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interceptor que inyecta el Bearer token en cada peticion
/// y redirige al login cuando recibe un 401.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.onUnauthorized, FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final VoidCallback onUnauthorized;

  /// Cache en memoria del token para evitar leer storage en cada request.
  String? _cachedToken;

  /// Endpoints que NO requieren token.
  static const _publicEndpoints = ['/auth/login', '/auth/register'];

  static const _unauthorizedSkipPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/logout',
    '/auth/me',
  ];

  /// Carga el token desde secure storage al cache.
  Future<void> loadToken() async {
    _cachedToken = await _storage.read(key: 'auth_token');
  }

  /// Actualiza el cache del token (llamado tras login/registro exitoso).
  void setCachedToken(String token) {
    _cachedToken = token;
  }

  /// Limpia el cache (llamado en logout).
  void clearCachedToken() {
    _cachedToken = null;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // No inyectar token en endpoints publicos
    final isPublic = _publicEndpoints.any(
      (path) => options.path.contains(path),
    );

    if (!isPublic && _cachedToken != null) {
      options.headers['Authorization'] = 'Bearer $_cachedToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final isAuthEndpoint = _unauthorizedSkipPaths.any(
        (path) => err.requestOptions.path.contains(path),
      );
      if (!isAuthEndpoint) {
        _cachedToken = null;
        await _storage.deleteAll();
        onUnauthorized();
      }
    }
    handler.next(err);
  }
}

/// Callback sin argumentos invocado cuando se detecta un 401.
typedef VoidCallback = void Function();
