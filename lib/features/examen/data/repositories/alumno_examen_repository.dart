import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/examenes_local_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/notifications/notifications_service.dart';
import '../../../grid/data/datasources/laravel_grid_datasource.dart';
import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../domain/entities/examen.dart';

class AlumnoExamenRepository extends GridRepositoryImpl<Examen> {
  AlumnoExamenRepository()
    : _ds = LaravelGridDatasource(
        const LaravelResourceController('/mis-examenes'),
        dio: DioClient.instance,
      ),
      super(controller: const LaravelResourceController('/mis-examenes'));

  static ExamenesLocalDatasource? _localOverride;
  static NotificationsService? _notifications;
  static void configure({
    required ExamenesLocalDatasource local,
    required NotificationsService notifications,
  }) {
    _localOverride = local;
    _notifications = notifications;
  }

  ExamenesLocalDatasource get _local =>
      _localOverride ??
      (throw StateError(
        'AlumnoExamenRepository not configured. Call AlumnoExamenRepository.configure() at app startup.',
      ));

  NotificationsService? get _notificationsService => _notifications;

  final LaravelGridDatasource _ds;

  static const int _pageSize = 15;
  static const Duration _autoLead = Duration(hours: 3);
  static const Duration _minLead = Duration(minutes: 1);

  @override
  Examen fromJson(Map<String, dynamic> json) => Examen.fromJson(json);

  @override
  Future<PaginatedResult<Examen>> fetchPage(
    int page, {
    Map<String, dynamic>? query,
  }) async {
    final isOnline = await _hasConnection();
    if (isOnline) {
      try {
        await _fullSync(query: query);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AlumnoExamenRepository sync failed: $e');
        }
      }
    }
    return _paginateLocal(page, query: query);
  }

  Future<void> _fullSync({Map<String, dynamic>? query}) async {
    int p = 1;
    final all = <Examen>[];
    while (true) {
      final response = await _ds.fetchPage(p, query: query);
      all.addAll(
        response.data
            .map((dynamic e) => Examen.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      final lastPage = response.meta?['last_page'] as int? ?? p;
      if (p >= lastPage) break;
      p++;
    }
    await _local.replaceAll(all);
    await _scheduleAutoForAll(all);
  }

  Future<void> _scheduleAutoForAll(List<Examen> examenes) async {
    final svc = _notificationsService;
    if (svc == null) return;
    for (final e in examenes) {
      await _scheduleAutoFor(e);
    }
  }

  Future<void> _scheduleAutoFor(Examen e) async {
    final svc = _notificationsService;
    if (svc == null) return;
    final idInt = int.tryParse(e.id) ?? 0;
    if (idInt == 0) return;
    final existing = await svc.getForExamen(idInt);
    if (existing.any((n) => n.tipo == 'auto' && !n.cancelled)) {
      return;
    }
    final lead = e.horario.difference(DateTime.now());
    if (lead <= Duration.zero) return;
    final fireAt = lead <= _autoLead + _minLead
        ? e.horario.subtract(_minLead)
        : e.horario.subtract(_autoLead);
    if (!fireAt.isAfter(DateTime.now())) return;
    await svc.scheduleAt(
      examenId: idInt,
      fireAt: fireAt,
      title: 'Recordatorio de examen',
      body:
          'Tu examen "${e.descripcion}" es en ${_humanizeLead(lead <= _autoLead + _minLead ? _minLead : _autoLead)}.',
      tipo: 'auto',
    );
  }

  String _humanizeLead(Duration d) {
    if (d.inHours >= 1) {
      final h = d.inHours;
      return h == 1 ? '1 hora' : '$h horas';
    }
    if (d.inMinutes >= 1) {
      final m = d.inMinutes;
      return m == 1 ? '1 minuto' : '$m minutos';
    }
    return 'instantes';
  }

  Future<PaginatedResult<Examen>> _paginateLocal(
    int page, {
    Map<String, dynamic>? query,
  }) async {
    final all = await _local.getAll();
    final filtered = _applyFilters(all, query);
    filtered.sort((a, b) => a.horario.compareTo(b.horario));
    final total = filtered.length;
    final lastPage = total == 0 ? 1 : ((total + _pageSize - 1) ~/ _pageSize);
    final start = (page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, total);
    final items = start >= total ? <Examen>[] : filtered.sublist(start, end);
    return PaginatedResult<Examen>(
      items: items,
      currentPage: page,
      lastPage: lastPage,
      total: total,
    );
  }

  List<Examen> _applyFilters(List<Examen> items, Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) return items;
    return items.where((e) {
      if (query['activo'] == '1' && !e.activo) return false;
      final descQ = query['descripcion'];
      if (descQ is String && descQ.isNotEmpty) {
        if (!e.descripcion.toLowerCase().contains(descQ.toLowerCase())) {
          return false;
        }
      }
      final unidadQ = query['unidad_aprendizaje_id'];
      if (unidadQ != null && unidadQ.toString().isNotEmpty) {
        if (e.unidadAprendizajeId.toString() != unidadQ.toString()) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Future<void> delete(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) {
      throw ArgumentError('AlumnoExamenRepository.delete requires numeric id');
    }
    await _local.markPendingDelete(idInt);
    await _notificationsService?.cancelForExamen(idInt);
    final isOnline = await _hasConnection();
    if (!isOnline) return;
    try {
      await _ds.delete(id);
      await _local.removeRow(idInt);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        await _local.removeRow(idInt);
        return;
      }
      if (kDebugMode) {
        debugPrint('AlumnoExamenRepository.delete online failed: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AlumnoExamenRepository.delete online unexpected: $e');
      }
    }
  }

  Future<bool> _hasConnection() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Future<List<Examen>> getAllLocal() => _local.getAll();
}
