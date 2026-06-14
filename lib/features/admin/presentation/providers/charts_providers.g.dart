// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examenesPorCarrera)
final examenesPorCarreraProvider = ExamenesPorCarreraProvider._();

final class ExamenesPorCarreraProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChartData>,
          ChartData,
          FutureOr<ChartData>
        >
    with $FutureModifier<ChartData>, $FutureProvider<ChartData> {
  ExamenesPorCarreraProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examenesPorCarreraProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examenesPorCarreraHash();

  @$internal
  @override
  $FutureProviderElement<ChartData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ChartData> create(Ref ref) {
    return examenesPorCarrera(ref);
  }
}

String _$examenesPorCarreraHash() =>
    r'af545d7ac1c9a2e8386b4528129de94d04dfea16';

@ProviderFor(inscritosPorMateria)
final inscritosPorMateriaProvider = InscritosPorMateriaProvider._();

final class InscritosPorMateriaProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChartData>,
          ChartData,
          FutureOr<ChartData>
        >
    with $FutureModifier<ChartData>, $FutureProvider<ChartData> {
  InscritosPorMateriaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inscritosPorMateriaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inscritosPorMateriaHash();

  @$internal
  @override
  $FutureProviderElement<ChartData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ChartData> create(Ref ref) {
    return inscritosPorMateria(ref);
  }
}

String _$inscritosPorMateriaHash() =>
    r'b7776b0d0218681f5d17d13e2d98bc62c68177a8';
