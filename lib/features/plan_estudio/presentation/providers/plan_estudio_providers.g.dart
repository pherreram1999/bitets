// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_estudio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlanesEstudioGrid)
final planesEstudioGridProvider = PlanesEstudioGridFamily._();

final class PlanesEstudioGridProvider
    extends
        $AsyncNotifierProvider<
          PlanesEstudioGrid,
          PaginatedResult<PlanEstudio>
        > {
  PlanesEstudioGridProvider._({
    required PlanesEstudioGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'planesEstudioGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$planesEstudioGridHash();

  @override
  String toString() {
    return r'planesEstudioGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlanesEstudioGrid create() => PlanesEstudioGrid();

  @override
  bool operator ==(Object other) {
    return other is PlanesEstudioGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$planesEstudioGridHash() => r'074d1fec7ebfb2acabdfafafd76c85cfb9252f43';

final class PlanesEstudioGridFamily extends $Family
    with
        $ClassFamilyOverride<
          PlanesEstudioGrid,
          AsyncValue<PaginatedResult<PlanEstudio>>,
          PaginatedResult<PlanEstudio>,
          FutureOr<PaginatedResult<PlanEstudio>>,
          int
        > {
  PlanesEstudioGridFamily._()
    : super(
        retry: null,
        name: r'planesEstudioGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlanesEstudioGridProvider call(int page) =>
      PlanesEstudioGridProvider._(argument: page, from: this);

  @override
  String toString() => r'planesEstudioGridProvider';
}

abstract class _$PlanesEstudioGrid
    extends $AsyncNotifier<PaginatedResult<PlanEstudio>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<PlanEstudio>> build(int page);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<PlanEstudio>>,
              PaginatedResult<PlanEstudio>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<PlanEstudio>>,
                PaginatedResult<PlanEstudio>
              >,
              AsyncValue<PaginatedResult<PlanEstudio>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(PlanesEstudioFilters)
final planesEstudioFiltersProvider = PlanesEstudioFiltersProvider._();

final class PlanesEstudioFiltersProvider
    extends $NotifierProvider<PlanesEstudioFilters, Map<String, dynamic>> {
  PlanesEstudioFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planesEstudioFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planesEstudioFiltersHash();

  @$internal
  @override
  PlanesEstudioFilters create() => PlanesEstudioFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$planesEstudioFiltersHash() =>
    r'e8c22f408eaae5a532a69875629ed091ce30132c';

abstract class _$PlanesEstudioFilters extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
              Map<String, dynamic>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
