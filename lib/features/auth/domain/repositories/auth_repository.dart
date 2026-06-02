import '../entities/user.dart';

/// Interfaz del repositorio de autenticacion.
/// Define el contrato que debe cumplir cualquier implementacion.
abstract class AuthRepository {
  /// Inicia sesion con email y password. Retorna el usuario autenticado.
  Future<User> login({required String email, required String password});

  /// Registra un nuevo usuario. Retorna el usuario creado.
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// Obtiene el usuario actual usando el token almacenado.
  Future<User> getCurrentUser();

  /// Cierra sesion (remoto + local).
  Future<void> logout();

  /// Verifica si hay un token guardado localmente.
  Future<bool> hasStoredToken();

  /// Obtiene el token guardado localmente.
  Future<String?> getStoredToken();

  /// Activa/desactiva el desbloqueo biometrico.
  Future<void> setBiometricEnabled(bool enabled);

  /// Verifica si el desbloqueo biometrico esta activado.
  Future<bool> isBiometricEnabled();

  /// Solicita autenticacion biometrica (huella/rostro).
  /// Retorna true si la autenticacion fue exitosa.
  Future<bool> authenticateWithBiometrics();
}
