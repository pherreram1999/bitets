import '../../../grid/domain/entities/has_id.dart';

class Area extends HasId {
  const Area({
    required this.id,
    required this.nombre,
    required this.clave,
    this.observaciones,
  });

  @override
  final String id;
  final String nombre;
  final String clave;
  final String? observaciones;

  factory Area.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Area(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      clave: (json['clave'] as String?) ?? '',
      observaciones: json['observaciones'] as String?,
    );
  }
}
