import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart' as domain;

part 'user_model.g.dart';

/// Modelo de datos para User. Incluye serializacion JSON y conversion a entidad.
@JsonSerializable()
class UserModel {
  final int id;
  final String name;
  final String email;
  final String rol;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.rol,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convierte el modelo a la entidad de dominio.
  domain.User toEntity() => domain.User(
        id: id,
        name: name,
        email: email,
        rol: rol,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory UserModel.fromEntity(domain.User user) => UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        rol: user.rol,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
}
