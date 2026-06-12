class ApiConstants {
  ApiConstants._();

  static String baseUrl = 'http://127.0.0.1:8000/api/v1';

  static const Duration timeout = Duration(seconds: 30);

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
}
