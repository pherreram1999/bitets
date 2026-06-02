import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';

/// Fuente de datos remota: realiza las peticiones HTTP a la API.
class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  /// POST /auth/login
  Future<AuthResponseModel> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data);
  }

  /// POST /auth/register
  /// Nota: este endpoint solo devuelve token, no user.
  /// Despues del registro llamamos a getCurrentUser para obtener los datos.
  Future<String> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return response.data['token'] as String;
  }

  /// GET /auth/me
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiConstants.me);
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /auth/logout
  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }
}
