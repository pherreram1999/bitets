// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edificio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EdificiosDataset)
final edificiosDatasetProvider = EdificiosDatasetFamily._();

final class EdificiosDatasetProvider
    extends $AsyncNotifierProvider<EdificiosDataset, List<Edificio>> {
  EdificiosDatasetProvider._({
    required EdificiosDatasetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'edificiosDatasetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$edificiosDatasetHash();

  @override
  String toString() {
    return r'edificiosDatasetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EdificiosDataset create() => EdificiosDataset();

  @override
  bool operator ==(Object other) {
    return other is EdificiosDatasetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$edificiosDatasetHash() => r'c1787bb121072d6e71cac3658673ad7e5fd7b94f';

final class EdificiosDatasetFamily extends $Family
    with
        $ClassFamilyOverride<
          EdificiosDataset,
          AsyncValue<List<Edificio>>,
          List<Edificio>,
          FutureOr<List<Edificio>>,
          String
        > {
  EdificiosDatasetFamily._()
    : super(
        retry: null,
        name: r'edificiosDatasetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EdificiosDatasetProvider call(String query) =>
      EdificiosDatasetProvider._(argument: query, from: this);

  @override
  String toString() => r'edificiosDatasetProvider';
}

abstract class _$EdificiosDataset extends $AsyncNotifier<List<Edificio>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<Edificio>> build(String query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Edificio>>, List<Edificio>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Edificio>>, List<Edificio>>,
              AsyncValue<List<Edificio>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(EdificiosGrid)
final edificiosGridProvider = EdificiosGridFamily._();

final class EdificiosGridProvider
    extends $AsyncNotifierProvider<EdificiosGrid, PaginatedResult<Edificio>> {
  EdificiosGridProvider._({
    required EdificiosGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'edificiosGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$edificiosGridHash();

  @override
  String toString() {
    return r'edificiosGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EdificiosGrid create() => EdificiosGrid();

  @override
  bool operator ==(Object other) {
    return other is EdificiosGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$edificiosGridHash() => r'1958ef4081e7433d3d46724b947060a9dd2eecbc';

final class EdificiosGridFamily extends $Family
    with
        $ClassFamilyOverride<
          EdificiosGrid,
          AsyncValue<PaginatedResult<Edificio>>,
          PaginatedResult<Edificio>,
          FutureOr<PaginatedResult<Edificio>>,
          int
        > {
  EdificiosGridFamily._()
    : super(
        retry: null,
        name: r'edificiosGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EdificiosGridProvider call(int page) =>
      EdificiosGridProvider._(argument: page, from: this);

  @override
  String toString() => r'edificiosGridProvider';
}

abstract class _$EdificiosGrid
    extends $AsyncNotifier<PaginatedResult<Edificio>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<Edificio>> build(int page);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<Edificio>>,
              PaginatedResult<Edificio>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Edificio>>,
                PaginatedResult<Edificio>
              >,
              AsyncValue<PaginatedResult<Edificio>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(EdificiosFilters)
final edificiosFiltersProvider = EdificiosFiltersProvider._();

final class EdificiosFiltersProvider
    extends $NotifierProvider<EdificiosFilters, Map<String, dynamic>> {
  EdificiosFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'edificiosFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$edificiosFiltersHash();

  @$internal
  @override
  EdificiosFilters create() => EdificiosFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$edificiosFiltersHash() => r'390c8e4b249f06eb4ee55ee42cecb4bbabf1a819';

abstract class _$EdificiosFilters extends $Notifier<Map<String, dynamic>> {
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
