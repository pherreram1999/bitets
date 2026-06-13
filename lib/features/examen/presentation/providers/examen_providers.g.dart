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

@ProviderFor(AlumnoExamenesGrid)
final alumnoExamenesGridProvider = AlumnoExamenesGridFamily._();

final class AlumnoExamenesGridProvider
    extends
        $AsyncNotifierProvider<AlumnoExamenesGrid, PaginatedResult<Examen>> {
  AlumnoExamenesGridProvider._({
    required AlumnoExamenesGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'alumnoExamenesGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$alumnoExamenesGridHash();

  @override
  String toString() {
    return r'alumnoExamenesGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlumnoExamenesGrid create() => AlumnoExamenesGrid();

  @override
  bool operator ==(Object other) {
    return other is AlumnoExamenesGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$alumnoExamenesGridHash() =>
    r'4170117e7a930d5417a655ac140bfc1704fd2ded';

final class AlumnoExamenesGridFamily extends $Family
    with
        $ClassFamilyOverride<
          AlumnoExamenesGrid,
          AsyncValue<PaginatedResult<Examen>>,
          PaginatedResult<Examen>,
          FutureOr<PaginatedResult<Examen>>,
          int
        > {
  AlumnoExamenesGridFamily._()
    : super(
        retry: null,
        name: r'alumnoExamenesGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlumnoExamenesGridProvider call(int page) =>
      AlumnoExamenesGridProvider._(argument: page, from: this);

  @override
  String toString() => r'alumnoExamenesGridProvider';
}

abstract class _$AlumnoExamenesGrid
    extends $AsyncNotifier<PaginatedResult<Examen>> {
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

@ProviderFor(AlumnoExamenesFilters)
final alumnoExamenesFiltersProvider = AlumnoExamenesFiltersProvider._();

final class AlumnoExamenesFiltersProvider
    extends $NotifierProvider<AlumnoExamenesFilters, Map<String, dynamic>> {
  AlumnoExamenesFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumnoExamenesFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumnoExamenesFiltersHash();

  @$internal
  @override
  AlumnoExamenesFilters create() => AlumnoExamenesFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$alumnoExamenesFiltersHash() =>
    r'fcb4cf93c6a2d12967e9a112a47aa126e678e2f2';

abstract class _$AlumnoExamenesFilters extends $Notifier<Map<String, dynamic>> {
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

@ProviderFor(EnrolledExamenIds)
final enrolledExamenIdsProvider = EnrolledExamenIdsProvider._();

final class EnrolledExamenIdsProvider
    extends $AsyncNotifierProvider<EnrolledExamenIds, Set<String>> {
  EnrolledExamenIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enrolledExamenIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enrolledExamenIdsHash();

  @$internal
  @override
  EnrolledExamenIds create() => EnrolledExamenIds();
}

String _$enrolledExamenIdsHash() => r'1e877274d2ee81f0cc14074492d8e905c84ab80b';

abstract class _$EnrolledExamenIds extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AlumnoCatalogoExamenesFilters)
final alumnoCatalogoExamenesFiltersProvider =
    AlumnoCatalogoExamenesFiltersProvider._();

final class AlumnoCatalogoExamenesFiltersProvider
    extends
        $NotifierProvider<AlumnoCatalogoExamenesFilters, Map<String, dynamic>> {
  AlumnoCatalogoExamenesFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumnoCatalogoExamenesFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumnoCatalogoExamenesFiltersHash();

  @$internal
  @override
  AlumnoCatalogoExamenesFilters create() => AlumnoCatalogoExamenesFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$alumnoCatalogoExamenesFiltersHash() =>
    r'f101cf5fc67937a963bb6c08a3b311160e1defb9';

abstract class _$AlumnoCatalogoExamenesFilters
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

@ProviderFor(AlumnoCatalogoExamenesGrid)
final alumnoCatalogoExamenesGridProvider = AlumnoCatalogoExamenesGridFamily._();

final class AlumnoCatalogoExamenesGridProvider
    extends
        $AsyncNotifierProvider<
          AlumnoCatalogoExamenesGrid,
          PaginatedResult<Examen>
        > {
  AlumnoCatalogoExamenesGridProvider._({
    required AlumnoCatalogoExamenesGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'alumnoCatalogoExamenesGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$alumnoCatalogoExamenesGridHash();

  @override
  String toString() {
    return r'alumnoCatalogoExamenesGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlumnoCatalogoExamenesGrid create() => AlumnoCatalogoExamenesGrid();

  @override
  bool operator ==(Object other) {
    return other is AlumnoCatalogoExamenesGridProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$alumnoCatalogoExamenesGridHash() =>
    r'5b34144a610524b7ac031bca3e7f3a1fb8a1812d';

final class AlumnoCatalogoExamenesGridFamily extends $Family
    with
        $ClassFamilyOverride<
          AlumnoCatalogoExamenesGrid,
          AsyncValue<PaginatedResult<Examen>>,
          PaginatedResult<Examen>,
          FutureOr<PaginatedResult<Examen>>,
          int
        > {
  AlumnoCatalogoExamenesGridFamily._()
    : super(
        retry: null,
        name: r'alumnoCatalogoExamenesGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlumnoCatalogoExamenesGridProvider call(int page) =>
      AlumnoCatalogoExamenesGridProvider._(argument: page, from: this);

  @override
  String toString() => r'alumnoCatalogoExamenesGridProvider';
}

abstract class _$AlumnoCatalogoExamenesGrid
    extends $AsyncNotifier<PaginatedResult<Examen>> {
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
