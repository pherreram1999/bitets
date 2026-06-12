import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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

  Future<String> _getDeviceName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        final web = await deviceInfo.webBrowserInfo;
        return 'web-${web.browserName.name}';
      }
      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        return '${android.manufacturer}-${android.model}';
      }
      if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        return ios.utsname.machine;
      }
      if (Platform.isLinux) {
        final linux = await deviceInfo.linuxInfo;
        return 'linux-${linux.name}';
      }
      if (Platform.isMacOS) {
        final mac = await deviceInfo.macOsInfo;
        return 'macos-${mac.model}';
      }
      if (Platform.isWindows) {
        final windows = await deviceInfo.windowsInfo;
        return 'windows-${windows.computerName}';
      }
    } catch (_) {}
    return 'bitets-app';
  }

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();

    final hasToken = await _repository.hasStoredToken();
    if (!hasToken) {
      state = const AuthState.unauthenticated();
      return;
    }

    // Token exists. NEVER restore session without validating identity.
    // Always require unlock (biometric or password) — storedSession UI handles both.
    final userName = await _repository.getStoredUserName();
    state = AuthState.storedSession(userName);
  }

  Future<void> loginWithBiometrics() async {
    final userName = await _repository.getStoredUserName();
    state = const AuthState.loading();

    final authenticated = await _repository.authenticateWithBiometrics();
    if (!authenticated) {
      state = AuthState.storedSession(userName);
      return;
    }

    final token = await _repository.getStoredToken();
    _interceptor.setCachedToken(token ?? '');

    try {
      final user = await _repository.getCurrentUser();
      state = AuthState.authenticated(user);
    } catch (e) {
      await _repository.logout();
      _interceptor.clearCachedToken();
      state = const AuthState.unauthenticated();
      if (kDebugMode) {
        debugPrint('loginWithBiometrics error: $e');
      }
    }
  }

  Future<void> login(String identificador, String password) async {
    state = const AuthState.loading();

    try {
      final deviceName = await _getDeviceName();
      final user = await _repository.login(
        identificador: identificador,
        password: password,
        deviceName: deviceName,
      );

      final token = await _repository.getStoredToken();
      _interceptor.setCachedToken(token ?? '');

      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      _logDioError('login', e);
      final message = _extractErrorMessage(e);
      state = AuthState.unauthenticated(message);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('login error (no-Dio): $e');
        debugPrint('login stack: $st');
      }
      state = AuthState.unauthenticated(
        'No se pudo completar el inicio de sesion. Intenta de nuevo.',
      );
    }
  }

  Future<void> register(
    String name,
    String email,
    String identificador,
    String password,
    String passwordConfirmation,
  ) async {
    state = const AuthState.loading();

    try {
      final deviceName = await _getDeviceName();
      final user = await _repository.register(
        name: name,
        email: email,
        identificador: identificador,
        password: password,
        passwordConfirmation: passwordConfirmation,
        deviceName: deviceName,
      );

      final token = await _repository.getStoredToken();
      _interceptor.setCachedToken(token ?? '');

      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      _logDioError('register', e);
      final message = _extractErrorMessage(e);
      state = AuthState.unauthenticated(message);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('register error (no-Dio): $e');
        debugPrint('register stack: $st');
      }
      state = AuthState.unauthenticated(
        'No se pudo completar el registro. Intenta de nuevo.',
      );
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    await _repository.logout();
    _interceptor.clearCachedToken();
    state = const AuthState.unauthenticated();
  }

  Future<void> clearStoredSession() async {
    await _repository.logout();
    _interceptor.clearCachedToken();
    state = const AuthState.unauthenticated();
  }

  Future<bool> enableBiometrics() async {
    final authenticated = await _repository.authenticateWithBiometrics();
    if (authenticated) {
      await _repository.setBiometricEnabled(true);
    }
    return authenticated;
  }

  Future<bool> needsBiometricSetup() async {
    final canUse = await _repository.canCheckBiometrics();
    if (!canUse) return false;
    return !(await _repository.isBiometricEnabled());
  }

  void _handleUnauthorized() {
    _repository.logout().then((_) {
      state = const AuthState.unauthenticated();
    });
  }

  void _logDioError(String tag, DioException e) {
    if (!kDebugMode) return;
    debugPrint(
      '[$tag] DioException type=${e.type} '
      'status=${e.response?.statusCode} '
      'message=${e.message}',
    );
    final data = e.response?.data;
    if (data != null) {
      debugPrint('[$tag] response body: $data');
    }
    if (e.requestOptions.data != null) {
      debugPrint('[$tag] request body: ${e.requestOptions.data}');
    }
  }

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
