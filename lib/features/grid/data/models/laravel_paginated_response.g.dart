// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laravel_paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaravelPaginatedResponse _$LaravelPaginatedResponseFromJson(
  Map<String, dynamic> json,
) => LaravelPaginatedResponse(
  data: json['data'] as List<dynamic>,
  links: json['links'] as Map<String, dynamic>?,
  meta: json['meta'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LaravelPaginatedResponseToJson(
  LaravelPaginatedResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'links': instance.links,
  'meta': instance.meta,
};
