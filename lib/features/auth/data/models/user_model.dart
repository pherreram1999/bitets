import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart' as domain;

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? identificador;
  final String rol;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.identificador,
    required this.rol,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  domain.User toEntity() => domain.User(
    id: id,
    name: name,
    email: email,
    identificador: identificador,
    rol: rol,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory UserModel.fromEntity(domain.User user) => UserModel(
    id: user.id,
    name: user.name,
    email: user.email,
    identificador: user.identificador,
    rol: user.rol,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  );
}
