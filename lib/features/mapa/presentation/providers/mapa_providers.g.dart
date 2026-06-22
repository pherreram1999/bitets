// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapa_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapaCanvas)
final mapaCanvasProvider = MapaCanvasProvider._();

final class MapaCanvasProvider
    extends $AsyncNotifierProvider<MapaCanvas, MapaCanvasResponse> {
  MapaCanvasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapaCanvasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapaCanvasHash();

  @$internal
  @override
  MapaCanvas create() => MapaCanvas();
}

String _$mapaCanvasHash() => r'0a4d1d24c1a4de1804bfa98ad6d7a84908c7e355';

abstract class _$MapaCanvas extends $AsyncNotifier<MapaCanvasResponse> {
  FutureOr<MapaCanvasResponse> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MapaCanvasResponse>, MapaCanvasResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MapaCanvasResponse>, MapaCanvasResponse>,
              AsyncValue<MapaCanvasResponse>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(examenesPorEdificioNumero)
final examenesPorEdificioNumeroProvider = ExamenesPorEdificioNumeroProvider._();

final class ExamenesPorEdificioNumeroProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, List<Examen>>>,
          Map<int, List<Examen>>,
          FutureOr<Map<int, List<Examen>>>
        >
    with
        $FutureModifier<Map<int, List<Examen>>>,
        $FutureProvider<Map<int, List<Examen>>> {
  ExamenesPorEdificioNumeroProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examenesPorEdificioNumeroProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examenesPorEdificioNumeroHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, List<Examen>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<Examen>>> create(Ref ref) {
    return examenesPorEdificioNumero(ref);
  }
}

String _$examenesPorEdificioNumeroHash() =>
    r'ce68a4a2e297c4a20583c32ad738f30c33bc0d9d';
