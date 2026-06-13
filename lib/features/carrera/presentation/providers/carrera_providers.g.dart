// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrera_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CarreraGrid)
final carreraGridProvider = CarreraGridFamily._();

final class CarreraGridProvider
    extends $AsyncNotifierProvider<CarreraGrid, PaginatedResult<Carrera>> {
  CarreraGridProvider._({
    required CarreraGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'carreraGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$carreraGridHash();

  @override
  String toString() {
    return r'carreraGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CarreraGrid create() => CarreraGrid();

  @override
  bool operator ==(Object other) {
    return other is CarreraGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$carreraGridHash() => r'c48467b46a108666354c3a8579fba153377a81b5';

final class CarreraGridFamily extends $Family
    with
        $ClassFamilyOverride<
          CarreraGrid,
          AsyncValue<PaginatedResult<Carrera>>,
          PaginatedResult<Carrera>,
          FutureOr<PaginatedResult<Carrera>>,
          int
        > {
  CarreraGridFamily._()
    : super(
        retry: null,
        name: r'carreraGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CarreraGridProvider call(int page) =>
      CarreraGridProvider._(argument: page, from: this);

  @override
  String toString() => r'carreraGridProvider';
}

abstract class _$CarreraGrid extends $AsyncNotifier<PaginatedResult<Carrera>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<Carrera>> build(int page);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<Carrera>>,
              PaginatedResult<Carrera>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Carrera>>,
                PaginatedResult<Carrera>
              >,
              AsyncValue<PaginatedResult<Carrera>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(CarrerasFilters)
final carrerasFiltersProvider = CarrerasFiltersProvider._();

final class CarrerasFiltersProvider
    extends $NotifierProvider<CarrerasFilters, Map<String, dynamic>> {
  CarrerasFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'carrerasFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$carrerasFiltersHash();

  @$internal
  @override
  CarrerasFilters create() => CarrerasFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$carrerasFiltersHash() => r'e02405f7c062860a7a24b2fca44edc22ec3938b0';

abstract class _$CarrerasFilters extends $Notifier<Map<String, dynamic>> {
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
