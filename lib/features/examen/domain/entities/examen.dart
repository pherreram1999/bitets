import '../../../auth/domain/entities/user.dart';
import '../../../grid/domain/entities/has_id.dart';
import '../../../profesores/domain/entities/profesor.dart';
import '../../../salon/domain/entities/salon.dart';
import '../../../unidad_aprendizaje/domain/entities/unidad_aprendizaje.dart';

class Examen extends HasId {
  const Examen({
    required this.id,
    required this.descripcion,
    required this.horario,
    required this.userId,
    required this.unidadAprendizajeId,
    required this.profesorId,
    required this.salonId,
    this.activo = true,
    this.usuario,
    this.unidadAprendizaje,
    this.profesor,
    this.salon,
  });

  @override
  final String id;
  final String descripcion;
  final DateTime horario;
  final int userId;
  final int unidadAprendizajeId;
  final int profesorId;
  final int salonId;
  final bool activo;

  final User? usuario;
  final UnidadAprendizaje? unidadAprendizaje;
  final Profesor? profesor;
  final Salon? salon;

  factory Examen.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Examen(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      descripcion: (json['descripcion'] as String?) ?? '',
      horario:
          DateTime.tryParse(json['horario'] as String? ?? '') ?? DateTime.now(),
      userId: _asInt(json['user_id']) ?? 0,
      unidadAprendizajeId: _asInt(json['unidad_aprendizaje_id']) ?? 0,
      profesorId: _asInt(json['profesor_id']) ?? 0,
      salonId: _asInt(json['salon_id']) ?? 0,
      activo: _asBool(json['activo']),
      usuario: _tryParse(json, 'usuario', User.fromJson),
      unidadAprendizaje: _tryParse(
        json,
        'unidad_aprendizaje',
        UnidadAprendizaje.fromJson,
      ),
      profesor: _tryParse(json, 'profesor', Profesor.fromJson),
      salon: _tryParse(json, 'salon', Salon.fromJson),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lowered = value.toLowerCase();
      if (lowered == 'true' || lowered == '1') return true;
      if (lowered == 'false' || lowered == '0') return false;
    }
    return false;
  }

  static T? _tryParse<T>(
    Map<String, dynamic> json,
    String key,
    T Function(Map<String, dynamic>) factory,
  ) {
    final raw = json[key];
    if (raw is! Map) return null;
    try {
      return factory(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }
}
