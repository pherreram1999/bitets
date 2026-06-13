import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/examen/domain/entities/examen.dart';
import '../../features/profesores/domain/entities/profesor.dart';
import '../../features/salon/domain/entities/salon.dart';
import '../../features/unidad_aprendizaje/domain/entities/unidad_aprendizaje.dart';
import 'app_database.dart';

class ExamenesLocalDatasource {
  ExamenesLocalDatasource(this._db);

  final AppDatabase _db;

  Stream<List<Examen>> watchAll() {
    final query = _db.select(_db.examenesCache)
      ..where((t) => t.pendingDelete.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.horario)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (r) =>
                Examen.fromJson(jsonDecode(r.payload) as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Future<List<Examen>> getAll() async {
    final rows =
        await (_db.select(_db.examenesCache)
              ..where((t) => t.pendingDelete.equals(false))
              ..orderBy([(t) => OrderingTerm.asc(t.horario)]))
            .get();
    return rows
        .map(
          (r) => Examen.fromJson(jsonDecode(r.payload) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> replaceAll(List<Examen> examenes) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.delete(_db.examenesCache).go();
      for (final e in examenes) {
        await _db
            .into(_db.examenesCache)
            .insert(
              ExamenesCacheCompanion.insert(
                id: Value(int.parse(e.id)),
                payload: jsonEncode(_serializeExamen(e)),
                descripcion: Value(e.descripcion),
                horario: e.horario,
                activo: Value(e.activo),
                pendingDelete: const Value(false),
                cachedAt: now,
              ),
            );
      }
    });
  }

  Future<void> markPendingDelete(int id) async {
    await (_db.update(_db.examenesCache)..where((t) => t.id.equals(id))).write(
      ExamenesCacheCompanion(
        pendingDelete: const Value(true),
        pendingDeleteAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> removeRow(int id) async {
    await (_db.delete(_db.examenesCache)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ExamenesCacheData>> getPendingDeletes() {
    return (_db.select(
      _db.examenesCache,
    )..where((t) => t.pendingDelete.equals(true))).get();
  }

  Map<String, dynamic> _serializeExamen(Examen e) => {
    'id': int.tryParse(e.id) ?? 0,
    'descripcion': e.descripcion,
    'horario': e.horario.toIso8601String(),
    'user_id': e.userId,
    'unidad_aprendizaje_id': e.unidadAprendizajeId,
    'profesor_id': e.profesorId,
    'salon_id': e.salonId,
    'activo': e.activo,
    if (e.usuario != null) 'usuario': _userToJson(e.usuario!),
    if (e.unidadAprendizaje != null)
      'unidad_aprendizaje': _unidadToJson(e.unidadAprendizaje!),
    if (e.profesor != null) 'profesor': _profesorToJson(e.profesor!),
    if (e.salon != null) 'salon': _salonToJson(e.salon!),
  };

  Map<String, dynamic> _userToJson(User u) => {
    'id': u.id,
    'name': u.name,
    'email': u.email,
    'identificador': u.identificador,
    'rol': u.rol,
    'created_at': u.createdAt.toIso8601String(),
    'updated_at': u.updatedAt.toIso8601String(),
  };

  Map<String, dynamic> _unidadToJson(UnidadAprendizaje u) => {
    'id': int.tryParse(u.id) ?? 0,
    'nombre': u.nombre,
    'carrera_id': u.carreraId,
    'plan_estudio_id': u.planEstudioId,
    'semestre': u.semestre,
  };

  Map<String, dynamic> _profesorToJson(Profesor p) => {
    'id': int.tryParse(p.id) ?? 0,
    'nombre': p.nombre,
    'email': p.email,
    'area_id': p.areaId,
  };

  Map<String, dynamic> _salonToJson(Salon s) => {
    'id': int.tryParse(s.id) ?? 0,
    'nombre': s.nombre,
    'edificio_id': s.edificioId,
    if (s.edificio != null)
      'edificio': {'id': s.edificio!.id, 'nombre': s.edificio!.nombre},
  };
}
