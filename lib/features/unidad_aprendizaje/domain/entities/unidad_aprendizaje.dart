import '../../../grid/domain/entities/has_id.dart';

class UnidadAprendizaje extends HasId {
  const UnidadAprendizaje({
    required this.id,
    required this.nombre,
    required this.carreraId,
    required this.planEstudioId,
    this.semestre,
  });

  @override
  final String id;
  final String nombre;
  final int carreraId;
  final int planEstudioId;
  final int? semestre;

  factory UnidadAprendizaje.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return UnidadAprendizaje(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      carreraId: (json['carrera_id'] as num?)?.toInt() ?? 0,
      planEstudioId: (json['plan_estudio_id'] as num?)?.toInt() ?? 0,
      semestre: (json['semestre'] as num?)?.toInt(),
    );
  }
}
