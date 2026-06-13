import 'package:local_auth/local_auth.dart';
import '../../../../core/database/user_local_datasource.dart';
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
    UserLocalDatasource? userCache,
  }) : _local = local ?? AuthLocalDatasource(),
       _remote = remote ?? AuthRemoteDatasource(),
       _localAuth = localAuth ?? LocalAuthentication(),
       _userCache = userCache;

  final AuthLocalDatasource _local;
  final AuthRemoteDatasource _remote;
  final LocalAuthentication _localAuth;
  final UserLocalDatasource? _userCache;

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

    final user = response.user.toEntity();
    await _local.saveToken(response.token);
    await _local.saveUserInfo(user);
    await _userCache?.saveUser(user);
    return user;
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

    final user = response.user.toEntity();
    await _local.saveToken(response.token);
    await _local.saveUserInfo(user);
    await _userCache?.saveUser(user);
    return user;
  }

  @override
  Future<User> getCurrentUser() async {
    final userModel = await _remote.getCurrentUser();
    final user = userModel.toEntity();
    await _local.saveUserInfo(user);
    await _userCache?.saveUser(user);
    return user;
  }

  @override
  Future<User?> getCachedUser() => _userCache?.getUser() ?? Future.value(null);

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await _local.clearAll();
    await _userCache?.clear();
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
