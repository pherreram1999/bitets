import '../../../grid/domain/entities/has_id.dart';

class Carrera extends HasId {
  const Carrera({required this.id, required this.nombre});

  @override
  final String id;
  final String nombre;

  factory Carrera.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Carrera(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
    );
  }
}
