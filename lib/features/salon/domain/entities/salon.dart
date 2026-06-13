import '../../../edificio/domain/entities/edificio.dart';
import '../../../grid/domain/entities/has_id.dart';

class Salon extends HasId {
  const Salon({
    required this.id,
    required this.nombre,
    required this.edificioId,
    this.edificio,
  });

  @override
  final String id;
  final String nombre;
  final int edificioId;
  final Edificio? edificio;

  factory Salon.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final edificioJson = json['edificio'];
    return Salon(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      edificioId: (json['edificio_id'] as num?)?.toInt() ?? 0,
      edificio: edificioJson is Map
          ? Edificio.fromJson(Map<String, dynamic>.from(edificioJson))
          : null,
    );
  }
}
