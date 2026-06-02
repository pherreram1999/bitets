import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Entidad de dominio que representa un usuario autenticado.
@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String rol;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.rol,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
