import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/local_providers.dart';
import '../../../examen/domain/entities/examen.dart';
import '../../../examen/presentation/providers/examen_providers.dart';
import '../../data/repositories/mapa_repository.dart';
import '../../domain/entities/mapa_canvas_response.dart';

part 'mapa_providers.g.dart';

final mapaRepositoryProvider = Provider<MapaRepository>((ref) {
  return MapaRepository(local: ref.watch(mapaLocalDatasourceProvider));
});

@riverpod
class MapaCanvas extends _$MapaCanvas {
  @override
  Future<MapaCanvasResponse> build() {
    return ref.read(mapaRepositoryProvider).fetchCanvas();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(mapaRepositoryProvider).fetchCanvas(),
    );
  }
}

@riverpod
Future<Map<int, List<Examen>>> examenesPorEdificioNumero(Ref ref) async {
  final repo = ref.read(alumnoExamenRepositoryProvider);
  final all = await repo.getAllLocal();
  final map = <int, List<Examen>>{};
  for (final e in all) {
    final numero = e.salon?.edificio?.numero;
    if (numero != null) {
      map.putIfAbsent(numero, () => []).add(e);
    }
  }
  return map;
}
