import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';

/// Fuente de datos local que gestiona el almacenamiento seguro
/// del token, datos de usuario y preferencias biometricas.
class AuthLocalDatasource {
  AuthLocalDatasource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  // ── Keys ──
  static const _tokenKey = 'auth_token';
  static const _userNameKey = 'user_name';
  static const _biometricKey = 'biometric_enabled';

  // ── Token ──

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ── User info (cache minima para UI rapida) ──

  Future<void> saveUserInfo(User user) async {
    await _storage.write(key: _userNameKey, value: user.name);
  }

  Future<String?> getUserName() async {
    return _storage.read(key: _userNameKey);
  }

  // ── Biometric ──

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricKey);
    return value == 'true';
  }

  // ── Limpieza total ──

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
