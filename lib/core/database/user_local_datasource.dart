import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import '../../features/auth/domain/entities/user.dart';
import 'app_database.dart';

class UserLocalDatasource {
  UserLocalDatasource(this._db);

  final AppDatabase _db;

  static const int _singleRowId = 1;

  Future<void> saveUser(User user) async {
    await _db
        .into(_db.userCache)
        .insertOnConflictUpdate(
          UserCacheCompanion.insert(
            id: const Value(_singleRowId),
            payload: jsonEncode(user.toJson()),
            cachedAt: DateTime.now(),
          ),
        );
  }

  Future<User?> getUser() async {
    final row =
        await (_db.select(_db.userCache)
              ..where((t) => t.id.equals(_singleRowId))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    try {
      return User.fromJson(jsonDecode(row.payload) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await (_db.delete(
      _db.userCache,
    )..where((t) => t.id.equals(_singleRowId))).go();
  }
}
