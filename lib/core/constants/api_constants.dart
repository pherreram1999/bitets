/// Configuracion centralizada de la API REST.
class ApiConstants {
  ApiConstants._();

  /// URL base segun el entorno.
  /// En debug apunta al servidor local; en release al dominio de produccion.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://bitets.test/api/v1',
  );

  /// Timeout por defecto para las peticiones HTTP.
  static const Duration timeout = Duration(seconds: 30);

  // ── Auth ──
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
}
