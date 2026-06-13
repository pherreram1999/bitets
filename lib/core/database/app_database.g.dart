// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExamenesCacheTable extends ExamenesCache
    with TableInfo<$ExamenesCacheTable, ExamenesCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamenesCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _horarioMeta = const VerificationMeta(
    'horario',
  );
  @override
  late final GeneratedColumn<DateTime> horario = GeneratedColumn<DateTime>(
    'horario',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _pendingDeleteMeta = const VerificationMeta(
    'pendingDelete',
  );
  @override
  late final GeneratedColumn<bool> pendingDelete = GeneratedColumn<bool>(
    'pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendingDeleteAtMeta = const VerificationMeta(
    'pendingDeleteAt',
  );
  @override
  late final GeneratedColumn<DateTime> pendingDeleteAt =
      GeneratedColumn<DateTime>(
        'pending_delete_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    payload,
    descripcion,
    horario,
    activo,
    pendingDelete,
    pendingDeleteAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examenes_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamenesCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('horario')) {
      context.handle(
        _horarioMeta,
        horario.isAcceptableOrUnknown(data['horario']!, _horarioMeta),
      );
    } else if (isInserting) {
      context.missing(_horarioMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('pending_delete')) {
      context.handle(
        _pendingDeleteMeta,
        pendingDelete.isAcceptableOrUnknown(
          data['pending_delete']!,
          _pendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('pending_delete_at')) {
      context.handle(
        _pendingDeleteAtMeta,
        pendingDeleteAt.isAcceptableOrUnknown(
          data['pending_delete_at']!,
          _pendingDeleteAtMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamenesCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamenesCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      horario: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}horario'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      pendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_delete'],
      )!,
      pendingDeleteAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pending_delete_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ExamenesCacheTable createAlias(String alias) {
    return $ExamenesCacheTable(attachedDatabase, alias);
  }
}

class ExamenesCacheData extends DataClass
    implements Insertable<ExamenesCacheData> {
  final int id;
  final String payload;
  final String descripcion;
  final DateTime horario;
  final bool activo;
  final bool pendingDelete;
  final DateTime? pendingDeleteAt;
  final DateTime cachedAt;
  const ExamenesCacheData({
    required this.id,
    required this.payload,
    required this.descripcion,
    required this.horario,
    required this.activo,
    required this.pendingDelete,
    this.pendingDeleteAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payload'] = Variable<String>(payload);
    map['descripcion'] = Variable<String>(descripcion);
    map['horario'] = Variable<DateTime>(horario);
    map['activo'] = Variable<bool>(activo);
    map['pending_delete'] = Variable<bool>(pendingDelete);
    if (!nullToAbsent || pendingDeleteAt != null) {
      map['pending_delete_at'] = Variable<DateTime>(pendingDeleteAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ExamenesCacheCompanion toCompanion(bool nullToAbsent) {
    return ExamenesCacheCompanion(
      id: Value(id),
      payload: Value(payload),
      descripcion: Value(descripcion),
      horario: Value(horario),
      activo: Value(activo),
      pendingDelete: Value(pendingDelete),
      pendingDeleteAt: pendingDeleteAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingDeleteAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory ExamenesCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamenesCacheData(
      id: serializer.fromJson<int>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      horario: serializer.fromJson<DateTime>(json['horario']),
      activo: serializer.fromJson<bool>(json['activo']),
      pendingDelete: serializer.fromJson<bool>(json['pendingDelete']),
      pendingDeleteAt: serializer.fromJson<DateTime?>(json['pendingDeleteAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'payload': serializer.toJson<String>(payload),
      'descripcion': serializer.toJson<String>(descripcion),
      'horario': serializer.toJson<DateTime>(horario),
      'activo': serializer.toJson<bool>(activo),
      'pendingDelete': serializer.toJson<bool>(pendingDelete),
      'pendingDeleteAt': serializer.toJson<DateTime?>(pendingDeleteAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  ExamenesCacheData copyWith({
    int? id,
    String? payload,
    String? descripcion,
    DateTime? horario,
    bool? activo,
    bool? pendingDelete,
    Value<DateTime?> pendingDeleteAt = const Value.absent(),
    DateTime? cachedAt,
  }) => ExamenesCacheData(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    descripcion: descripcion ?? this.descripcion,
    horario: horario ?? this.horario,
    activo: activo ?? this.activo,
    pendingDelete: pendingDelete ?? this.pendingDelete,
    pendingDeleteAt: pendingDeleteAt.present
        ? pendingDeleteAt.value
        : this.pendingDeleteAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  ExamenesCacheData copyWithCompanion(ExamenesCacheCompanion data) {
    return ExamenesCacheData(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      horario: data.horario.present ? data.horario.value : this.horario,
      activo: data.activo.present ? data.activo.value : this.activo,
      pendingDelete: data.pendingDelete.present
          ? data.pendingDelete.value
          : this.pendingDelete,
      pendingDeleteAt: data.pendingDeleteAt.present
          ? data.pendingDeleteAt.value
          : this.pendingDeleteAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamenesCacheData(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('descripcion: $descripcion, ')
          ..write('horario: $horario, ')
          ..write('activo: $activo, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('pendingDeleteAt: $pendingDeleteAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    payload,
    descripcion,
    horario,
    activo,
    pendingDelete,
    pendingDeleteAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamenesCacheData &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.descripcion == this.descripcion &&
          other.horario == this.horario &&
          other.activo == this.activo &&
          other.pendingDelete == this.pendingDelete &&
          other.pendingDeleteAt == this.pendingDeleteAt &&
          other.cachedAt == this.cachedAt);
}

class ExamenesCacheCompanion extends UpdateCompanion<ExamenesCacheData> {
  final Value<int> id;
  final Value<String> payload;
  final Value<String> descripcion;
  final Value<DateTime> horario;
  final Value<bool> activo;
  final Value<bool> pendingDelete;
  final Value<DateTime?> pendingDeleteAt;
  final Value<DateTime> cachedAt;
  const ExamenesCacheCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.horario = const Value.absent(),
    this.activo = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.pendingDeleteAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  ExamenesCacheCompanion.insert({
    this.id = const Value.absent(),
    required String payload,
    this.descripcion = const Value.absent(),
    required DateTime horario,
    this.activo = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.pendingDeleteAt = const Value.absent(),
    required DateTime cachedAt,
  }) : payload = Value(payload),
       horario = Value(horario),
       cachedAt = Value(cachedAt);
  static Insertable<ExamenesCacheData> custom({
    Expression<int>? id,
    Expression<String>? payload,
    Expression<String>? descripcion,
    Expression<DateTime>? horario,
    Expression<bool>? activo,
    Expression<bool>? pendingDelete,
    Expression<DateTime>? pendingDeleteAt,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (descripcion != null) 'descripcion': descripcion,
      if (horario != null) 'horario': horario,
      if (activo != null) 'activo': activo,
      if (pendingDelete != null) 'pending_delete': pendingDelete,
      if (pendingDeleteAt != null) 'pending_delete_at': pendingDeleteAt,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  ExamenesCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? payload,
    Value<String>? descripcion,
    Value<DateTime>? horario,
    Value<bool>? activo,
    Value<bool>? pendingDelete,
    Value<DateTime?>? pendingDeleteAt,
    Value<DateTime>? cachedAt,
  }) {
    return ExamenesCacheCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      descripcion: descripcion ?? this.descripcion,
      horario: horario ?? this.horario,
      activo: activo ?? this.activo,
      pendingDelete: pendingDelete ?? this.pendingDelete,
      pendingDeleteAt: pendingDeleteAt ?? this.pendingDeleteAt,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (horario.present) {
      map['horario'] = Variable<DateTime>(horario.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (pendingDelete.present) {
      map['pending_delete'] = Variable<bool>(pendingDelete.value);
    }
    if (pendingDeleteAt.present) {
      map['pending_delete_at'] = Variable<DateTime>(pendingDeleteAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamenesCacheCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('descripcion: $descripcion, ')
          ..write('horario: $horario, ')
          ..write('activo: $activo, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('pendingDeleteAt: $pendingDeleteAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $UserCacheTable extends UserCache
    with TableInfo<$UserCacheTable, UserCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $UserCacheTable createAlias(String alias) {
    return $UserCacheTable(attachedDatabase, alias);
  }
}

class UserCacheData extends DataClass implements Insertable<UserCacheData> {
  final int id;
  final String payload;
  final DateTime cachedAt;
  const UserCacheData({
    required this.id,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UserCacheCompanion toCompanion(bool nullToAbsent) {
    return UserCacheCompanion(
      id: Value(id),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory UserCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCacheData(
      id: serializer.fromJson<int>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  UserCacheData copyWith({int? id, String? payload, DateTime? cachedAt}) =>
      UserCacheData(
        id: id ?? this.id,
        payload: payload ?? this.payload,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  UserCacheData copyWithCompanion(UserCacheCompanion data) {
    return UserCacheData(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCacheData(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCacheData &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class UserCacheCompanion extends UpdateCompanion<UserCacheData> {
  final Value<int> id;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  const UserCacheCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  UserCacheCompanion.insert({
    this.id = const Value.absent(),
    required String payload,
    required DateTime cachedAt,
  }) : payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<UserCacheData> custom({
    Expression<int>? id,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  UserCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
  }) {
    return UserCacheCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCacheCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificacionExamenTable extends NotificacionExamen
    with TableInfo<$NotificacionExamenTable, NotificacionExamenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificacionExamenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _examenIdMeta = const VerificationMeta(
    'examenId',
  );
  @override
  late final GeneratedColumn<int> examenId = GeneratedColumn<int>(
    'examen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<DateTime> fireAt = GeneratedColumn<DateTime>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cancelledMeta = const VerificationMeta(
    'cancelled',
  );
  @override
  late final GeneratedColumn<bool> cancelled = GeneratedColumn<bool>(
    'cancelled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cancelled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examenId,
    notificationId,
    tipo,
    fireAt,
    cancelled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notificacion_examen';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificacionExamenData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examen_id')) {
      context.handle(
        _examenIdMeta,
        examenId.isAcceptableOrUnknown(data['examen_id']!, _examenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_examenIdMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('cancelled')) {
      context.handle(
        _cancelledMeta,
        cancelled.isAcceptableOrUnknown(data['cancelled']!, _cancelledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificacionExamenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificacionExamenData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      examenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}examen_id'],
      )!,
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      fireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fire_at'],
      )!,
      cancelled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cancelled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotificacionExamenTable createAlias(String alias) {
    return $NotificacionExamenTable(attachedDatabase, alias);
  }
}

class NotificacionExamenData extends DataClass
    implements Insertable<NotificacionExamenData> {
  final int id;
  final int examenId;
  final int notificationId;
  final String tipo;
  final DateTime fireAt;
  final bool cancelled;
  final DateTime createdAt;
  const NotificacionExamenData({
    required this.id,
    required this.examenId,
    required this.notificationId,
    required this.tipo,
    required this.fireAt,
    required this.cancelled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['examen_id'] = Variable<int>(examenId);
    map['notification_id'] = Variable<int>(notificationId);
    map['tipo'] = Variable<String>(tipo);
    map['fire_at'] = Variable<DateTime>(fireAt);
    map['cancelled'] = Variable<bool>(cancelled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotificacionExamenCompanion toCompanion(bool nullToAbsent) {
    return NotificacionExamenCompanion(
      id: Value(id),
      examenId: Value(examenId),
      notificationId: Value(notificationId),
      tipo: Value(tipo),
      fireAt: Value(fireAt),
      cancelled: Value(cancelled),
      createdAt: Value(createdAt),
    );
  }

  factory NotificacionExamenData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificacionExamenData(
      id: serializer.fromJson<int>(json['id']),
      examenId: serializer.fromJson<int>(json['examenId']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      fireAt: serializer.fromJson<DateTime>(json['fireAt']),
      cancelled: serializer.fromJson<bool>(json['cancelled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'examenId': serializer.toJson<int>(examenId),
      'notificationId': serializer.toJson<int>(notificationId),
      'tipo': serializer.toJson<String>(tipo),
      'fireAt': serializer.toJson<DateTime>(fireAt),
      'cancelled': serializer.toJson<bool>(cancelled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotificacionExamenData copyWith({
    int? id,
    int? examenId,
    int? notificationId,
    String? tipo,
    DateTime? fireAt,
    bool? cancelled,
    DateTime? createdAt,
  }) => NotificacionExamenData(
    id: id ?? this.id,
    examenId: examenId ?? this.examenId,
    notificationId: notificationId ?? this.notificationId,
    tipo: tipo ?? this.tipo,
    fireAt: fireAt ?? this.fireAt,
    cancelled: cancelled ?? this.cancelled,
    createdAt: createdAt ?? this.createdAt,
  );
  NotificacionExamenData copyWithCompanion(NotificacionExamenCompanion data) {
    return NotificacionExamenData(
      id: data.id.present ? data.id.value : this.id,
      examenId: data.examenId.present ? data.examenId.value : this.examenId,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      cancelled: data.cancelled.present ? data.cancelled.value : this.cancelled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificacionExamenData(')
          ..write('id: $id, ')
          ..write('examenId: $examenId, ')
          ..write('notificationId: $notificationId, ')
          ..write('tipo: $tipo, ')
          ..write('fireAt: $fireAt, ')
          ..write('cancelled: $cancelled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examenId,
    notificationId,
    tipo,
    fireAt,
    cancelled,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificacionExamenData &&
          other.id == this.id &&
          other.examenId == this.examenId &&
          other.notificationId == this.notificationId &&
          other.tipo == this.tipo &&
          other.fireAt == this.fireAt &&
          other.cancelled == this.cancelled &&
          other.createdAt == this.createdAt);
}

class NotificacionExamenCompanion
    extends UpdateCompanion<NotificacionExamenData> {
  final Value<int> id;
  final Value<int> examenId;
  final Value<int> notificationId;
  final Value<String> tipo;
  final Value<DateTime> fireAt;
  final Value<bool> cancelled;
  final Value<DateTime> createdAt;
  const NotificacionExamenCompanion({
    this.id = const Value.absent(),
    this.examenId = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NotificacionExamenCompanion.insert({
    this.id = const Value.absent(),
    required int examenId,
    required int notificationId,
    required String tipo,
    required DateTime fireAt,
    this.cancelled = const Value.absent(),
    required DateTime createdAt,
  }) : examenId = Value(examenId),
       notificationId = Value(notificationId),
       tipo = Value(tipo),
       fireAt = Value(fireAt),
       createdAt = Value(createdAt);
  static Insertable<NotificacionExamenData> custom({
    Expression<int>? id,
    Expression<int>? examenId,
    Expression<int>? notificationId,
    Expression<String>? tipo,
    Expression<DateTime>? fireAt,
    Expression<bool>? cancelled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examenId != null) 'examen_id': examenId,
      if (notificationId != null) 'notification_id': notificationId,
      if (tipo != null) 'tipo': tipo,
      if (fireAt != null) 'fire_at': fireAt,
      if (cancelled != null) 'cancelled': cancelled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NotificacionExamenCompanion copyWith({
    Value<int>? id,
    Value<int>? examenId,
    Value<int>? notificationId,
    Value<String>? tipo,
    Value<DateTime>? fireAt,
    Value<bool>? cancelled,
    Value<DateTime>? createdAt,
  }) {
    return NotificacionExamenCompanion(
      id: id ?? this.id,
      examenId: examenId ?? this.examenId,
      notificationId: notificationId ?? this.notificationId,
      tipo: tipo ?? this.tipo,
      fireAt: fireAt ?? this.fireAt,
      cancelled: cancelled ?? this.cancelled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (examenId.present) {
      map['examen_id'] = Variable<int>(examenId.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<DateTime>(fireAt.value);
    }
    if (cancelled.present) {
      map['cancelled'] = Variable<bool>(cancelled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificacionExamenCompanion(')
          ..write('id: $id, ')
          ..write('examenId: $examenId, ')
          ..write('notificationId: $notificationId, ')
          ..write('tipo: $tipo, ')
          ..write('fireAt: $fireAt, ')
          ..write('cancelled: $cancelled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExamenesCacheTable examenesCache = $ExamenesCacheTable(this);
  late final $UserCacheTable userCache = $UserCacheTable(this);
  late final $NotificacionExamenTable notificacionExamen =
      $NotificacionExamenTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    examenesCache,
    userCache,
    notificacionExamen,
  ];
}

typedef $$ExamenesCacheTableCreateCompanionBuilder =
    ExamenesCacheCompanion Function({
      Value<int> id,
      required String payload,
      Value<String> descripcion,
      required DateTime horario,
      Value<bool> activo,
      Value<bool> pendingDelete,
      Value<DateTime?> pendingDeleteAt,
      required DateTime cachedAt,
    });
typedef $$ExamenesCacheTableUpdateCompanionBuilder =
    ExamenesCacheCompanion Function({
      Value<int> id,
      Value<String> payload,
      Value<String> descripcion,
      Value<DateTime> horario,
      Value<bool> activo,
      Value<bool> pendingDelete,
      Value<DateTime?> pendingDeleteAt,
      Value<DateTime> cachedAt,
    });

class $$ExamenesCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ExamenesCacheTable> {
  $$ExamenesCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get horario => $composableBuilder(
    column: $table.horario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pendingDeleteAt => $composableBuilder(
    column: $table.pendingDeleteAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamenesCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamenesCacheTable> {
  $$ExamenesCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get horario => $composableBuilder(
    column: $table.horario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pendingDeleteAt => $composableBuilder(
    column: $table.pendingDeleteAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamenesCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamenesCacheTable> {
  $$ExamenesCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get horario =>
      $composableBuilder(column: $table.horario, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pendingDeleteAt => $composableBuilder(
    column: $table.pendingDeleteAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ExamenesCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamenesCacheTable,
          ExamenesCacheData,
          $$ExamenesCacheTableFilterComposer,
          $$ExamenesCacheTableOrderingComposer,
          $$ExamenesCacheTableAnnotationComposer,
          $$ExamenesCacheTableCreateCompanionBuilder,
          $$ExamenesCacheTableUpdateCompanionBuilder,
          (
            ExamenesCacheData,
            BaseReferences<
              _$AppDatabase,
              $ExamenesCacheTable,
              ExamenesCacheData
            >,
          ),
          ExamenesCacheData,
          PrefetchHooks Function()
        > {
  $$ExamenesCacheTableTableManager(_$AppDatabase db, $ExamenesCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamenesCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamenesCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamenesCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<DateTime> horario = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<DateTime?> pendingDeleteAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => ExamenesCacheCompanion(
                id: id,
                payload: payload,
                descripcion: descripcion,
                horario: horario,
                activo: activo,
                pendingDelete: pendingDelete,
                pendingDeleteAt: pendingDeleteAt,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String payload,
                Value<String> descripcion = const Value.absent(),
                required DateTime horario,
                Value<bool> activo = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<DateTime?> pendingDeleteAt = const Value.absent(),
                required DateTime cachedAt,
              }) => ExamenesCacheCompanion.insert(
                id: id,
                payload: payload,
                descripcion: descripcion,
                horario: horario,
                activo: activo,
                pendingDelete: pendingDelete,
                pendingDeleteAt: pendingDeleteAt,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamenesCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamenesCacheTable,
      ExamenesCacheData,
      $$ExamenesCacheTableFilterComposer,
      $$ExamenesCacheTableOrderingComposer,
      $$ExamenesCacheTableAnnotationComposer,
      $$ExamenesCacheTableCreateCompanionBuilder,
      $$ExamenesCacheTableUpdateCompanionBuilder,
      (
        ExamenesCacheData,
        BaseReferences<_$AppDatabase, $ExamenesCacheTable, ExamenesCacheData>,
      ),
      ExamenesCacheData,
      PrefetchHooks Function()
    >;
typedef $$UserCacheTableCreateCompanionBuilder =
    UserCacheCompanion Function({
      Value<int> id,
      required String payload,
      required DateTime cachedAt,
    });
typedef $$UserCacheTableUpdateCompanionBuilder =
    UserCacheCompanion Function({
      Value<int> id,
      Value<String> payload,
      Value<DateTime> cachedAt,
    });

class $$UserCacheTableFilterComposer
    extends Composer<_$AppDatabase, $UserCacheTable> {
  $$UserCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCacheTable> {
  $$UserCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCacheTable> {
  $$UserCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$UserCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserCacheTable,
          UserCacheData,
          $$UserCacheTableFilterComposer,
          $$UserCacheTableOrderingComposer,
          $$UserCacheTableAnnotationComposer,
          $$UserCacheTableCreateCompanionBuilder,
          $$UserCacheTableUpdateCompanionBuilder,
          (
            UserCacheData,
            BaseReferences<_$AppDatabase, $UserCacheTable, UserCacheData>,
          ),
          UserCacheData,
          PrefetchHooks Function()
        > {
  $$UserCacheTableTableManager(_$AppDatabase db, $UserCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => UserCacheCompanion(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String payload,
                required DateTime cachedAt,
              }) => UserCacheCompanion.insert(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserCacheTable,
      UserCacheData,
      $$UserCacheTableFilterComposer,
      $$UserCacheTableOrderingComposer,
      $$UserCacheTableAnnotationComposer,
      $$UserCacheTableCreateCompanionBuilder,
      $$UserCacheTableUpdateCompanionBuilder,
      (
        UserCacheData,
        BaseReferences<_$AppDatabase, $UserCacheTable, UserCacheData>,
      ),
      UserCacheData,
      PrefetchHooks Function()
    >;
typedef $$NotificacionExamenTableCreateCompanionBuilder =
    NotificacionExamenCompanion Function({
      Value<int> id,
      required int examenId,
      required int notificationId,
      required String tipo,
      required DateTime fireAt,
      Value<bool> cancelled,
      required DateTime createdAt,
    });
typedef $$NotificacionExamenTableUpdateCompanionBuilder =
    NotificacionExamenCompanion Function({
      Value<int> id,
      Value<int> examenId,
      Value<int> notificationId,
      Value<String> tipo,
      Value<DateTime> fireAt,
      Value<bool> cancelled,
      Value<DateTime> createdAt,
    });

class $$NotificacionExamenTableFilterComposer
    extends Composer<_$AppDatabase, $NotificacionExamenTable> {
  $$NotificacionExamenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get examenId => $composableBuilder(
    column: $table.examenId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cancelled => $composableBuilder(
    column: $table.cancelled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificacionExamenTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificacionExamenTable> {
  $$NotificacionExamenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get examenId => $composableBuilder(
    column: $table.examenId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cancelled => $composableBuilder(
    column: $table.cancelled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificacionExamenTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificacionExamenTable> {
  $$NotificacionExamenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get examenId =>
      $composableBuilder(column: $table.examenId, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<DateTime> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<bool> get cancelled =>
      $composableBuilder(column: $table.cancelled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NotificacionExamenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificacionExamenTable,
          NotificacionExamenData,
          $$NotificacionExamenTableFilterComposer,
          $$NotificacionExamenTableOrderingComposer,
          $$NotificacionExamenTableAnnotationComposer,
          $$NotificacionExamenTableCreateCompanionBuilder,
          $$NotificacionExamenTableUpdateCompanionBuilder,
          (
            NotificacionExamenData,
            BaseReferences<
              _$AppDatabase,
              $NotificacionExamenTable,
              NotificacionExamenData
            >,
          ),
          NotificacionExamenData,
          PrefetchHooks Function()
        > {
  $$NotificacionExamenTableTableManager(
    _$AppDatabase db,
    $NotificacionExamenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificacionExamenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificacionExamenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificacionExamenTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> examenId = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<DateTime> fireAt = const Value.absent(),
                Value<bool> cancelled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotificacionExamenCompanion(
                id: id,
                examenId: examenId,
                notificationId: notificationId,
                tipo: tipo,
                fireAt: fireAt,
                cancelled: cancelled,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int examenId,
                required int notificationId,
                required String tipo,
                required DateTime fireAt,
                Value<bool> cancelled = const Value.absent(),
                required DateTime createdAt,
              }) => NotificacionExamenCompanion.insert(
                id: id,
                examenId: examenId,
                notificationId: notificationId,
                tipo: tipo,
                fireAt: fireAt,
                cancelled: cancelled,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificacionExamenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificacionExamenTable,
      NotificacionExamenData,
      $$NotificacionExamenTableFilterComposer,
      $$NotificacionExamenTableOrderingComposer,
      $$NotificacionExamenTableAnnotationComposer,
      $$NotificacionExamenTableCreateCompanionBuilder,
      $$NotificacionExamenTableUpdateCompanionBuilder,
      (
        NotificacionExamenData,
        BaseReferences<
          _$AppDatabase,
          $NotificacionExamenTable,
          NotificacionExamenData
        >,
      ),
      NotificacionExamenData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExamenesCacheTableTableManager get examenesCache =>
      $$ExamenesCacheTableTableManager(_db, _db.examenesCache);
  $$UserCacheTableTableManager get userCache =>
      $$UserCacheTableTableManager(_db, _db.userCache);
  $$NotificacionExamenTableTableManager get notificacionExamen =>
      $$NotificacionExamenTableTableManager(_db, _db.notificacionExamen);
}
