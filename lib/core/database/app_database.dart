import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class ExamenesCache extends Table {
  IntColumn get id => integer()();
  TextColumn get payload => text()();
  TextColumn get descripcion => text().withDefault(const Constant(''))();
  DateTimeColumn get horario => dateTime()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  BoolColumn get pendingDelete =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get pendingDeleteAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class UserCache extends Table {
  IntColumn get id => integer()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class NotificacionExamen extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get examenId => integer()();
  IntColumn get notificationId => integer()();
  TextColumn get tipo => text()();
  DateTimeColumn get fireAt => dateTime()();
  BoolColumn get cancelled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class MapaCache extends Table {
  IntColumn get id => integer()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [ExamenesCache, UserCache, NotificacionExamen, MapaCache],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(driftDatabase(name: 'bitets_cache'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(notificacionExamen);
      }
      if (from < 3) {
        await m.createTable(mapaCache);
      }
    },
  );
}
