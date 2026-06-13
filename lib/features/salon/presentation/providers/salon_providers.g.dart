// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonesByEdificio)
final salonesByEdificioProvider = SalonesByEdificioFamily._();

final class SalonesByEdificioProvider
    extends $AsyncNotifierProvider<SalonesByEdificio, List<Salon>> {
  SalonesByEdificioProvider._({
    required SalonesByEdificioFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'salonesByEdificioProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonesByEdificioHash();

  @override
  String toString() {
    return r'salonesByEdificioProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonesByEdificio create() => SalonesByEdificio();

  @override
  bool operator ==(Object other) {
    return other is SalonesByEdificioProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonesByEdificioHash() => r'e700ce45582b99ba925149b92582c1f4ffc5c9bc';

final class SalonesByEdificioFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonesByEdificio,
          AsyncValue<List<Salon>>,
          List<Salon>,
          FutureOr<List<Salon>>,
          int
        > {
  SalonesByEdificioFamily._()
    : super(
        retry: null,
        name: r'salonesByEdificioProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonesByEdificioProvider call(int edificioId) =>
      SalonesByEdificioProvider._(argument: edificioId, from: this);

  @override
  String toString() => r'salonesByEdificioProvider';
}

abstract class _$SalonesByEdificio extends $AsyncNotifier<List<Salon>> {
  late final _$args = ref.$arg as int;
  int get edificioId => _$args;

  FutureOr<List<Salon>> build(int edificioId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Salon>>, List<Salon>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Salon>>, List<Salon>>,
              AsyncValue<List<Salon>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(SalonesGrid)
final salonesGridProvider = SalonesGridFamily._();

final class SalonesGridProvider
    extends $AsyncNotifierProvider<SalonesGrid, PaginatedResult<Salon>> {
  SalonesGridProvider._({
    required SalonesGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'salonesGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonesGridHash();

  @override
  String toString() {
    return r'salonesGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonesGrid create() => SalonesGrid();

  @override
  bool operator ==(Object other) {
    return other is SalonesGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonesGridHash() => r'5501a08530185173b2ef827951867677971a2b37';

final class SalonesGridFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonesGrid,
          AsyncValue<PaginatedResult<Salon>>,
          PaginatedResult<Salon>,
          FutureOr<PaginatedResult<Salon>>,
          int
        > {
  SalonesGridFamily._()
    : super(
        retry: null,
        name: r'salonesGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonesGridProvider call(int page) =>
      SalonesGridProvider._(argument: page, from: this);

  @override
  String toString() => r'salonesGridProvider';
}

abstract class _$SalonesGrid extends $AsyncNotifier<PaginatedResult<Salon>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<Salon>> build(int page);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PaginatedResult<Salon>>, PaginatedResult<Salon>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Salon>>,
                PaginatedResult<Salon>
              >,
              AsyncValue<PaginatedResult<Salon>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(SalonesFilters)
final salonesFiltersProvider = SalonesFiltersProvider._();

final class SalonesFiltersProvider
    extends $NotifierProvider<SalonesFilters, Map<String, dynamic>> {
  SalonesFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonesFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonesFiltersHash();

  @$internal
  @override
  SalonesFilters create() => SalonesFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$salonesFiltersHash() => r'0d9785608c907d2f2dbcb8db5e6faa120c0cc217';

abstract class _$SalonesFilters extends $Notifier<Map<String, dynamic>> {
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
