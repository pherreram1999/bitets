import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

/// Provider que gestiona todo el estado de autenticacion.
@riverpod
class Auth extends _$Auth {
  late final AuthRepository _repository;
  late final AuthInterceptor _interceptor;

  @override
  AuthState build() {
    _repository = AuthRepositoryImpl(
      local: AuthLocalDatasource(),
      remote: AuthRemoteDatasource(),
    );
    _interceptor = AuthInterceptor(onUnauthorized: _handleUnauthorized);
    DioClient.addAuthInterceptor(_interceptor);
    return const AuthState.initial();
  }

  /// Verifica el estado de autenticacion al iniciar la app.
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();

    final hasToken = await _repository.hasStoredToken();
    if (!hasToken) {
      state = const AuthState.unauthenticated();
      return;
    }

    // Verificar si la biometria esta activada
    final biometricEnabled = await _repository.isBiometricEnabled();
    if (biometricEnabled) {
      final authenticated = await _repository.authenticateWithBiometrics();
      if (!authenticated) {
        state = const AuthState.unauthenticated();
        return;
      }
    }

    // Cargar token en cache del interceptor
    final token = await _repository.getStoredToken();
    _interceptor.setCachedToken(token ?? '');

    // Validar token contra el servidor
    try {
      final user = await _repository.getCurrentUser();
      state = AuthState.authenticated(user);
    } catch (e) {
      await _repository.logout();
      _interceptor.clearCachedToken();
      state = const AuthState.unauthenticated();
      if (kDebugMode) {
        debugPrint('checkAuthStatus error: $e');
      }
    }
  }

  /// Inicia sesion con email y password.
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );

      final token = await _repository.getStoredToken();
      _interceptor.setCachedToken(token ?? '');

      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = AuthState.unauthenticated(message);
    } catch (e) {
      state = AuthState.unauthenticated('Error de conexion. Intenta de nuevo.');
    }
  }

  /// Registra un nuevo usuario.
  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    state = const AuthState.loading();

    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final token = await _repository.getStoredToken();
      _interceptor.setCachedToken(token ?? '');

      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = AuthState.unauthenticated(message);
    } catch (e) {
      state = AuthState.unauthenticated('Error de conexion. Intenta de nuevo.');
    }
  }

  /// Cierra sesion.
  Future<void> logout() async {
    state = const AuthState.loading();
    await _repository.logout();
    _interceptor.clearCachedToken();
    state = const AuthState.unauthenticated();
  }

  /// Activa el desbloqueo biometrico para futuros inicios de sesion.
  Future<bool> enableBiometrics() async {
    final authenticated = await _repository.authenticateWithBiometrics();
    if (authenticated) {
      await _repository.setBiometricEnabled(true);
    }
    return authenticated;
  }

  /// Indica si se debe mostrar el dialogo de configuracion biometrica.
  Future<bool> needsBiometricSetup() async {
    return !(await _repository.isBiometricEnabled());
  }

  /// Callback invocado por el AuthInterceptor cuando recibe un 401.
  void _handleUnauthorized() {
    _repository.logout().then((_) {
      state = const AuthState.unauthenticated();
    });
  }

  /// Extrae un mensaje legible de un DioException.
  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      if (data['message'] is String) {
        return data['message'] as String;
      }
      if (data['error'] is String) {
        return data['error'] as String;
      }
    }

    switch (e.response?.statusCode) {
      case 401:
        return 'Credenciales incorrectas.';
      case 422:
        return 'Datos invalidos. Verifica los campos.';
      case 500:
        return 'Error del servidor. Intenta mas tarde.';
      default:
        return 'Error de conexion. Verifica tu internet.';
    }
  }
}
