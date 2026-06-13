// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'areas_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AreasGrid)
final areasGridProvider = AreasGridFamily._();

final class AreasGridProvider
    extends $AsyncNotifierProvider<AreasGrid, PaginatedResult<Area>> {
  AreasGridProvider._({
    required AreasGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'areasGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$areasGridHash();

  @override
  String toString() {
    return r'areasGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AreasGrid create() => AreasGrid();

  @override
  bool operator ==(Object other) {
    return other is AreasGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$areasGridHash() => r'598e5bac99c1b1628c8b99a019b337fed531a93c';

final class AreasGridFamily extends $Family
    with
        $ClassFamilyOverride<
          AreasGrid,
          AsyncValue<PaginatedResult<Area>>,
          PaginatedResult<Area>,
          FutureOr<PaginatedResult<Area>>,
          int
        > {
  AreasGridFamily._()
    : super(
        retry: null,
        name: r'areasGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AreasGridProvider call(int page) =>
      AreasGridProvider._(argument: page, from: this);

  @override
  String toString() => r'areasGridProvider';
}

abstract class _$AreasGrid extends $AsyncNotifier<PaginatedResult<Area>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<Area>> build(int page);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PaginatedResult<Area>>, PaginatedResult<Area>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Area>>,
                PaginatedResult<Area>
              >,
              AsyncValue<PaginatedResult<Area>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(AreasFilters)
final areasFiltersProvider = AreasFiltersProvider._();

final class AreasFiltersProvider
    extends $NotifierProvider<AreasFilters, Map<String, dynamic>> {
  AreasFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areasFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areasFiltersHash();

  @$internal
  @override
  AreasFilters create() => AreasFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$areasFiltersHash() => r'0133aaac1171722fac87b1e2810a141d4487186e';

abstract class _$AreasFilters extends $Notifier<Map<String, dynamic>> {
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
