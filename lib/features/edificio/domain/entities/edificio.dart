import '../../../grid/domain/entities/has_id.dart';

class Edificio extends HasId {
  const Edificio({required this.id, required this.nombre});

  @override
  final String id;
  final String nombre;

  factory Edificio.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Edificio(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
    );
  }
}
