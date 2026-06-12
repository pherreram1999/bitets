import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<AuthResponseModel> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data);
  }

  Future<AuthResponseModel> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiConstants.me);
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }
}
