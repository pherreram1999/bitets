// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profesores_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$profesoresGridHash() => r'e462a74e74ea611a859a2d3feaa6d3c5c4d10747';

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
  void runBuild() {
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
    element.handleCreate(ref, () => build(_$args));
  }
}
