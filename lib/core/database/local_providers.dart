import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/examen/data/services/examenes_sync_service.dart';
import 'database_provider.dart';
import 'examenes_local_datasource.dart';
import 'mapa_local_datasource.dart';
import 'user_local_datasource.dart';

final examenesLocalDatasourceProvider = Provider<ExamenesLocalDatasource>((
  ref,
) {
  return ExamenesLocalDatasource(ref.watch(appDatabaseProvider));
});

final userLocalDatasourceProvider = Provider<UserLocalDatasource>((ref) {
  return UserLocalDatasource(ref.watch(appDatabaseProvider));
});

final mapaLocalDatasourceProvider = Provider<MapaLocalDatasource>((ref) {
  return MapaLocalDatasource(ref.watch(appDatabaseProvider));
});

final examenesSyncServiceProvider = Provider<ExamenesSyncService>((ref) {
  final local = ref.watch(examenesLocalDatasourceProvider);
  final service = ExamenesSyncService(local: local);
  ref.onDispose(service.dispose);
  return service;
});
