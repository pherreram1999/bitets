import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String identificador,
    required String password,
    required String deviceName,
  });

  Future<User> register({
    required String name,
    required String email,
    required String identificador,
    required String password,
    required String passwordConfirmation,
    required String deviceName,
    String rol = 'alumno',
  });

  Future<User> getCurrentUser();

  Future<User?> getCachedUser();

  Future<void> logout();

  Future<bool> hasStoredToken();

  Future<String?> getStoredToken();

  Future<String?> getStoredUserName();

  Future<void> setBiometricEnabled(bool enabled);

  Future<bool> isBiometricEnabled();

  Future<bool> authenticateWithBiometrics();

  Future<bool> canCheckBiometrics();
}
