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

String _$areasGridHash() => r'0820515b2091cabd545b81be8088392bbb0b12d8';

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
  void runBuild() {
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
    element.handleCreate(ref, () => build(_$args));
  }
}
