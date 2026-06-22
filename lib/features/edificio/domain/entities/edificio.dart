import '../../../grid/domain/entities/has_id.dart';
import '../../../salon/domain/entities/salon.dart';

class Edificio extends HasId {
  const Edificio({
    required this.id,
    required this.nombre,
    this.numero,
    this.salones = const [],
  });

  @override
  final String id;
  final String nombre;
  final int? numero;
  final List<Salon> salones;

  factory Edificio.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawSalones = json['salones'];
    return Edificio(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      numero: (json['numero'] as num?)?.toInt(),
      salones: rawSalones is List
          ? rawSalones
                .whereType<Map<String, dynamic>>()
                .map(Salon.fromJson)
                .toList(growable: false)
          : const <Salon>[],
    );
  }
}
