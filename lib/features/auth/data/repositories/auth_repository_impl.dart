import 'package:local_auth/local_auth.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

/// Implementacion concreta del AuthRepository.
/// Orquesta las fuentes de datos local y remota.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    AuthLocalDatasource? local,
    AuthRemoteDatasource? remote,
    LocalAuthentication? localAuth,
  })  : _local = local ?? AuthLocalDatasource(),
        _remote = remote ?? AuthRemoteDatasource(),
        _localAuth = localAuth ?? LocalAuthentication();

  final AuthLocalDatasource _local;
  final AuthRemoteDatasource _remote;
  final LocalAuthentication _localAuth;

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _remote.login(
      LoginRequest(email: email, password: password),
    );

    await _local.saveToken(response.token);
    await _local.saveUserInfo(response.user.toEntity());

    return response.user.toEntity();
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final token = await _remote.register(
      RegisterRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );

    // Guardar token y luego obtener los datos del usuario
    await _local.saveToken(token);
    final userModel = await _remote.getCurrentUser();
    await _local.saveUserInfo(userModel.toEntity());

    return userModel.toEntity();
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
    } catch (_) {
      // Si falla la llamada remota, igual limpiamos localmente
    }
    await _local.clearAll();
  }

  @override
  Future<bool> hasStoredToken() => _local.hasToken();

  @override
  Future<String?> getStoredToken() => _local.getToken();

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _local.setBiometricEnabled(enabled);
  }

  @override
  Future<bool> isBiometricEnabled() => _local.isBiometricEnabled();

  @override
  Future<bool> authenticateWithBiometrics() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    if (!canCheck) return false;

    final didAuthenticate = await _localAuth.authenticate(
      localizedReason: 'Desbloquea bitets para continuar',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );

    return didAuthenticate;
  }
}
