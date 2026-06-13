import '../../../grid/domain/entities/has_id.dart';

class PlanEstudio extends HasId {
  const PlanEstudio({
    required this.id,
    required this.nombre,
    required this.periodoInicial,
    required this.periodoFinal,
  });

  @override
  final String id;
  final String nombre;
  final DateTime periodoInicial;
  final DateTime periodoFinal;

  factory PlanEstudio.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return PlanEstudio(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      periodoInicial:
          DateTime.tryParse(json['periodo_inicial'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      periodoFinal:
          DateTime.tryParse(json['periodo_final'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
