import 'package:local_auth/local_auth.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    AuthLocalDatasource? local,
    AuthRemoteDatasource? remote,
    LocalAuthentication? localAuth,
  }) : _local = local ?? AuthLocalDatasource(),
       _remote = remote ?? AuthRemoteDatasource(),
       _localAuth = localAuth ?? LocalAuthentication();

  final AuthLocalDatasource _local;
  final AuthRemoteDatasource _remote;
  final LocalAuthentication _localAuth;

  @override
  Future<User> login({
    required String identificador,
    required String password,
    required String deviceName,
  }) async {
    final response = await _remote.login(
      LoginRequest(
        identificador: identificador,
        password: password,
        deviceName: deviceName,
      ),
    );

    await _local.saveToken(response.token);
    await _local.saveUserInfo(response.user.toEntity());

    return response.user.toEntity();
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String identificador,
    required String password,
    required String passwordConfirmation,
    required String deviceName,
    String rol = 'alumno',
  }) async {
    final response = await _remote.register(
      RegisterRequest(
        name: name,
        email: email,
        identificador: identificador,
        password: password,
        passwordConfirmation: passwordConfirmation,
        deviceName: deviceName,
        rol: rol,
      ),
    );

    await _local.saveToken(response.token);
    await _local.saveUserInfo(response.user.toEntity());

    return response.user.toEntity();
  }

  @override
  Future<User> getCurrentUser() async {
    final userModel = await _remote.getCurrentUser();
    await _local.saveUserInfo(userModel.toEntity());
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await _local.clearAll();
  }

  @override
  Future<bool> hasStoredToken() => _local.hasToken();

  @override
  Future<String?> getStoredToken() => _local.getToken();

  @override
  Future<String?> getStoredUserName() => _local.getUserName();

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _local.setBiometricEnabled(enabled);
  }

  @override
  Future<bool> isBiometricEnabled() => _local.isBiometricEnabled();

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Desbloquea bitets para continuar',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } catch (_) {
      // Sin biometria enrolada, bloqueo temporal o cancelacion del sistema.
      return false;
    }
  }

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }
}
