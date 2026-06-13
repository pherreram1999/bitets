// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profesores_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfesoresDataset)
final profesoresDatasetProvider = ProfesoresDatasetFamily._();

final class ProfesoresDatasetProvider
    extends $AsyncNotifierProvider<ProfesoresDataset, List<Profesor>> {
  ProfesoresDatasetProvider._({
    required ProfesoresDatasetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profesoresDatasetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profesoresDatasetHash();

  @override
  String toString() {
    return r'profesoresDatasetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfesoresDataset create() => ProfesoresDataset();

  @override
  bool operator ==(Object other) {
    return other is ProfesoresDatasetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profesoresDatasetHash() => r'1c5d85d2c7efbb29813e69f85b328913527f4ab1';

final class ProfesoresDatasetFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfesoresDataset,
          AsyncValue<List<Profesor>>,
          List<Profesor>,
          FutureOr<List<Profesor>>,
          String
        > {
  ProfesoresDatasetFamily._()
    : super(
        retry: null,
        name: r'profesoresDatasetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfesoresDatasetProvider call(String query) =>
      ProfesoresDatasetProvider._(argument: query, from: this);

  @override
  String toString() => r'profesoresDatasetProvider';
}

abstract class _$ProfesoresDataset extends $AsyncNotifier<List<Profesor>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<Profesor>> build(String query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Profesor>>, List<Profesor>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Profesor>>, List<Profesor>>,
              AsyncValue<List<Profesor>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ProfesoresGrid)
final profesoresGridProvider = ProfesoresGridFamily._();

final class ProfesoresGridProvider
    extends $AsyncNotifierProvider<ProfesoresGrid, PaginatedResult<Profesor>> {
  ProfesoresGridProvider._({
    required ProfesoresGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'profesoresGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profesoresGridHash();

  @override
  String toString() {
    return r'profesoresGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfesoresGrid create() => ProfesoresGrid();

  @override
  bool operator ==(Object other) {
    return other is ProfesoresGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profesoresGridHash() => r'2fab25a9619070047be83323a72d71ab852c3b9b';

final class ProfesoresGridFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfesoresGrid,
          AsyncValue<PaginatedResult<Profesor>>,
          PaginatedResult<Profesor>,
          FutureOr<PaginatedResult<Profesor>>,
          int
        > {
  ProfesoresGridFamily._()
    : super(
        retry: null,
        name: r'profesoresGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfesoresGridProvider call(int page) =>
      ProfesoresGridProvider._(argument: page, from: this);

  @override
  String toString() => r'profesoresGridProvider';
}

abstract class _$ProfesoresGrid
    extends $AsyncNotifier<PaginatedResult<Profesor>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<Profesor>> build(int page);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<Profesor>>,
              PaginatedResult<Profesor>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Profesor>>,
                PaginatedResult<Profesor>
              >,
              AsyncValue<PaginatedResult<Profesor>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ProfesoresFilters)
final profesoresFiltersProvider = ProfesoresFiltersProvider._();

final class ProfesoresFiltersProvider
    extends $NotifierProvider<ProfesoresFilters, Map<String, dynamic>> {
  ProfesoresFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profesoresFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profesoresFiltersHash();

  @$internal
  @override
  ProfesoresFilters create() => ProfesoresFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$profesoresFiltersHash() => r'a9990ef14bc26599352d55ae0d897bbed5ab08c3';

abstract class _$ProfesoresFilters extends $Notifier<Map<String, dynamic>> {
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
