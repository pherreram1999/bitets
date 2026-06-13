// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unidad_aprendizaje_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnidadesAprendizajeDataset)
final unidadesAprendizajeDatasetProvider = UnidadesAprendizajeDatasetFamily._();

final class UnidadesAprendizajeDatasetProvider
    extends
        $AsyncNotifierProvider<
          UnidadesAprendizajeDataset,
          List<UnidadAprendizaje>
        > {
  UnidadesAprendizajeDatasetProvider._({
    required UnidadesAprendizajeDatasetFamily super.from,
    required UnidadesAprendizajeDatasetArgs super.argument,
  }) : super(
         retry: null,
         name: r'unidadesAprendizajeDatasetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unidadesAprendizajeDatasetHash();

  @override
  String toString() {
    return r'unidadesAprendizajeDatasetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnidadesAprendizajeDataset create() => UnidadesAprendizajeDataset();

  @override
  bool operator ==(Object other) {
    return other is UnidadesAprendizajeDatasetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unidadesAprendizajeDatasetHash() =>
    r'23bb7956533e1e029e28cab904b7daa3cbe3e877';

final class UnidadesAprendizajeDatasetFamily extends $Family
    with
        $ClassFamilyOverride<
          UnidadesAprendizajeDataset,
          AsyncValue<List<UnidadAprendizaje>>,
          List<UnidadAprendizaje>,
          FutureOr<List<UnidadAprendizaje>>,
          UnidadesAprendizajeDatasetArgs
        > {
  UnidadesAprendizajeDatasetFamily._()
    : super(
        retry: null,
        name: r'unidadesAprendizajeDatasetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnidadesAprendizajeDatasetProvider call(
    UnidadesAprendizajeDatasetArgs args,
  ) => UnidadesAprendizajeDatasetProvider._(argument: args, from: this);

  @override
  String toString() => r'unidadesAprendizajeDatasetProvider';
}

abstract class _$UnidadesAprendizajeDataset
    extends $AsyncNotifier<List<UnidadAprendizaje>> {
  late final _$args = ref.$arg as UnidadesAprendizajeDatasetArgs;
  UnidadesAprendizajeDatasetArgs get args => _$args;

  FutureOr<List<UnidadAprendizaje>> build(UnidadesAprendizajeDatasetArgs args);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UnidadAprendizaje>>,
              List<UnidadAprendizaje>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UnidadAprendizaje>>,
                List<UnidadAprendizaje>
              >,
              AsyncValue<List<UnidadAprendizaje>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(UnidadesAprendizajeGrid)
final unidadesAprendizajeGridProvider = UnidadesAprendizajeGridFamily._();

final class UnidadesAprendizajeGridProvider
    extends
        $AsyncNotifierProvider<
          UnidadesAprendizajeGrid,
          PaginatedResult<UnidadAprendizaje>
        > {
  UnidadesAprendizajeGridProvider._({
    required UnidadesAprendizajeGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'unidadesAprendizajeGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unidadesAprendizajeGridHash();

  @override
  String toString() {
    return r'unidadesAprendizajeGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnidadesAprendizajeGrid create() => UnidadesAprendizajeGrid();

  @override
  bool operator ==(Object other) {
    return other is UnidadesAprendizajeGridProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unidadesAprendizajeGridHash() =>
    r'edd3ef1bb2827b537ef5e01bd2a694c0a0633b6d';

final class UnidadesAprendizajeGridFamily extends $Family
    with
        $ClassFamilyOverride<
          UnidadesAprendizajeGrid,
          AsyncValue<PaginatedResult<UnidadAprendizaje>>,
          PaginatedResult<UnidadAprendizaje>,
          FutureOr<PaginatedResult<UnidadAprendizaje>>,
          int
        > {
  UnidadesAprendizajeGridFamily._()
    : super(
        retry: null,
        name: r'unidadesAprendizajeGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnidadesAprendizajeGridProvider call(int page) =>
      UnidadesAprendizajeGridProvider._(argument: page, from: this);

  @override
  String toString() => r'unidadesAprendizajeGridProvider';
}

abstract class _$UnidadesAprendizajeGrid
    extends $AsyncNotifier<PaginatedResult<UnidadAprendizaje>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<UnidadAprendizaje>> build(int page);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<UnidadAprendizaje>>,
              PaginatedResult<UnidadAprendizaje>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<UnidadAprendizaje>>,
                PaginatedResult<UnidadAprendizaje>
              >,
              AsyncValue<PaginatedResult<UnidadAprendizaje>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(UnidadesAprendizajeFilters)
final unidadesAprendizajeFiltersProvider =
    UnidadesAprendizajeFiltersProvider._();

final class UnidadesAprendizajeFiltersProvider
    extends
        $NotifierProvider<UnidadesAprendizajeFilters, Map<String, dynamic>> {
  UnidadesAprendizajeFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unidadesAprendizajeFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unidadesAprendizajeFiltersHash();

  @$internal
  @override
  UnidadesAprendizajeFilters create() => UnidadesAprendizajeFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$unidadesAprendizajeFiltersHash() =>
    r'66b69eac565673fd6222d06f90cefef0cdb9d92b';

abstract class _$UnidadesAprendizajeFilters
    extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
              Map<String, dynamic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
