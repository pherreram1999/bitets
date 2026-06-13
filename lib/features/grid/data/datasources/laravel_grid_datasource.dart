import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/laravel_resource_controller.dart';
import '../models/laravel_paginated_response.dart';

class LaravelGridDatasource {
  LaravelGridDatasource(this._controller, {Dio? dio})
    : _dio = dio ?? DioClient.instance;

  final Dio _dio;
  final LaravelResourceController _controller;

  Future<LaravelPaginatedResponse> fetchPage(
    int page, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get(_controller.list(page: page, query: query));
    return LaravelPaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> show(String id) async {
    final response = await _dio.get(_controller.show(id));
    return _unwrapData(response.data);
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final response = await _dio.post(_controller.create(), data: data);
    return _unwrapData(response.data);
  }

  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(_controller.update(id), data: data);
    return _unwrapData(response.data);
  }

  Map<String, dynamic> _unwrapData(Object? body) {
    if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }
    return body as Map<String, dynamic>;
  }

  Future<void> delete(String id) async {
    await _dio.delete(_controller.delete(id));
  }
}
