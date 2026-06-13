import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../database/app_database.dart';
import '../database/database_provider.dart';

class NotificationsService {
  NotificationsService(this._db);

  final AppDatabase _db;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _androidChannelId = 'bitets_examenes';
  static const String _androidChannelName = 'Recordatorios de examenes';
  static const String _androidChannelDescription =
      'Avisos de examenes inscritos y recordatorios personalizados.';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationsService timezone fallback UTC: $e');
      }
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const linux = LinuxInitializationSettings(
      defaultActionName: 'Abrir bitets',
    );
    const windows = WindowsInitializationSettings(
      appName: 'bitets',
      appUserModelId: 'com.bitets.app',
      guid: 'c5b88f3a-3a1c-4a13-9c8b-2b3f7c0a0a01',
    );
    const settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
      linux: linux,
      windows: windows,
    );

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    }
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    if (Platform.isMacOS) {
      final macos = _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >();
      return await macos?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<int> scheduleAt({
    required int examenId,
    required DateTime fireAt,
    required String title,
    required String body,
    required String tipo,
  }) async {
    if (!_initialized) await initialize();
    if (!fireAt.isAfter(DateTime.now())) {
      return -1;
    }
    final id = _generateNotificationId(examenId, tipo, fireAt);
    final scheduled = tz.TZDateTime.from(fireAt, tz.local);
    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'examen:$examenId',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('zonedSchedule failed: $e');
      }
      return -1;
    }

    return _db
        .into(_db.notificacionExamen)
        .insert(
          NotificacionExamenCompanion.insert(
            examenId: examenId,
            notificationId: id,
            tipo: tipo,
            fireAt: fireAt,
            cancelled: const Value(false),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> cancelForExamen(int examenId) async {
    if (!_initialized) await initialize();
    final rows = await (_db.select(
      _db.notificacionExamen,
    )..where((t) => t.examenId.equals(examenId))).get();
    for (final row in rows) {
      await _plugin.cancel(id: row.notificationId);
    }
    await (_db.update(_db.notificacionExamen)
          ..where((t) => t.examenId.equals(examenId)))
        .write(const NotificacionExamenCompanion(cancelled: Value(true)));
  }

  Future<void> rescheduleAll() async {
    if (!_initialized) await initialize();
    final now = DateTime.now();
    final query = _db.select(_db.notificacionExamen)
      ..where((t) => t.cancelled.equals(false))
      ..where((t) => t.fireAt.isBiggerThanValue(now));
    final rows = await query.get();
    final pending = await _plugin.pendingNotificationRequests();
    final pendingIds = pending.map((p) => p.id).toSet();
    for (final row in rows) {
      if (pendingIds.contains(row.notificationId)) continue;
      try {
        final scheduled = tz.TZDateTime.from(row.fireAt, tz.local);
        const androidDetails = AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription: _androidChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );
        const details = NotificationDetails(android: androidDetails);
        await _plugin.zonedSchedule(
          id: row.notificationId,
          title: 'Recordatorio de examen',
          body: 'Tu examen esta por comenzar.',
          scheduledDate: scheduled,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: 'examen:${row.examenId}',
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('reschedule failed for ${row.notificationId}: $e');
        }
      }
    }
  }

  Future<List<NotificacionExamenData>> getForExamen(int examenId) {
    return (_db.select(_db.notificacionExamen)
          ..where((t) => t.examenId.equals(examenId))
          ..orderBy([(t) => OrderingTerm.asc(t.fireAt)]))
        .get();
  }

  Future<void> cancelById(int rowId) async {
    if (!_initialized) await initialize();
    final row = await (_db.select(
      _db.notificacionExamen,
    )..where((t) => t.id.equals(rowId))).getSingleOrNull();
    if (row == null) return;
    await _plugin.cancel(id: row.notificationId);
    await (_db.update(_db.notificacionExamen)..where((t) => t.id.equals(rowId)))
        .write(const NotificacionExamenCompanion(cancelled: Value(true)));
  }

  int _generateNotificationId(int examenId, String tipo, DateTime fireAt) {
    final base = (examenId & 0xFFFFFF) << 8;
    final t = (fireAt.millisecondsSinceEpoch ~/ 60000) & 0xFFFF;
    return (base | t) & 0x7FFFFFFF;
  }
}

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService(ref.watch(appDatabaseProvider));
});
