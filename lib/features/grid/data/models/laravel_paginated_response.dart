import 'package:json_annotation/json_annotation.dart';

part 'laravel_paginated_response.g.dart';

@JsonSerializable()
class LaravelPaginatedResponse {
  const LaravelPaginatedResponse({required this.data, this.links, this.meta});

  final List<dynamic> data;
  final Map<String, dynamic>? links;
  final Map<String, dynamic>? meta;

  factory LaravelPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$LaravelPaginatedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LaravelPaginatedResponseToJson(this);
}
