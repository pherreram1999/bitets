import '../../../grid/domain/entities/has_id.dart';

class Profesor extends HasId {
  const Profesor({
    required this.id,
    required this.nombre,
    required this.email,
    required this.areaId,
  });

  @override
  final String id;
  final String nombre;
  final String email;
  final int areaId;

  factory Profesor.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Profesor(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      areaId: (json['area_id'] as num?)?.toInt() ?? 0,
    );
  }
}
