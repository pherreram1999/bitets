// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examen_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExamenesGrid)
final examenesGridProvider = ExamenesGridFamily._();

final class ExamenesGridProvider
    extends $AsyncNotifierProvider<ExamenesGrid, PaginatedResult<Examen>> {
  ExamenesGridProvider._({
    required ExamenesGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'examenesGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$examenesGridHash();

  @override
  String toString() {
    return r'examenesGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExamenesGrid create() => ExamenesGrid();

  @override
  bool operator ==(Object other) {
    return other is ExamenesGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$examenesGridHash() => r'7ead64558a55c2f4025e92a22bbf54c97c8da071';

final class ExamenesGridFamily extends $Family
    with
        $ClassFamilyOverride<
          ExamenesGrid,
          AsyncValue<PaginatedResult<Examen>>,
          PaginatedResult<Examen>,
          FutureOr<PaginatedResult<Examen>>,
          int
        > {
  ExamenesGridFamily._()
    : super(
        retry: null,
        name: r'examenesGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExamenesGridProvider call(int page) =>
      ExamenesGridProvider._(argument: page, from: this);

  @override
  String toString() => r'examenesGridProvider';
}

abstract class _$ExamenesGrid extends $AsyncNotifier<PaginatedResult<Examen>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<PaginatedResult<Examen>> build(int page);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<Examen>>,
              PaginatedResult<Examen>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Examen>>,
                PaginatedResult<Examen>
              >,
              AsyncValue<PaginatedResult<Examen>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ExamenesFilters)
final examenesFiltersProvider = ExamenesFiltersProvider._();

final class ExamenesFiltersProvider
    extends $NotifierProvider<ExamenesFilters, Map<String, dynamic>> {
  ExamenesFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examenesFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examenesFiltersHash();

  @$internal
  @override
  ExamenesFilters create() => ExamenesFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$examenesFiltersHash() => r'2e1b1635fd5b858db14ed30bc2afec585b0d34bb';

abstract class _$ExamenesFilters extends $Notifier<Map<String, dynamic>> {
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
