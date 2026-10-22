// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionsByDateHash() => r'7bc1f4477895756b17e9a3d39ac3ecb9d42fbeac';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [sessionsByDate].
@ProviderFor(sessionsByDate)
const sessionsByDateProvider = SessionsByDateFamily();

/// See also [sessionsByDate].
class SessionsByDateFamily extends Family<AsyncValue<List<ClassSession>>> {
  /// See also [sessionsByDate].
  const SessionsByDateFamily();

  /// See also [sessionsByDate].
  SessionsByDateProvider call(DateTime date) {
    return SessionsByDateProvider(date);
  }

  @override
  SessionsByDateProvider getProviderOverride(
    covariant SessionsByDateProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionsByDateProvider';
}

/// See also [sessionsByDate].
class SessionsByDateProvider
    extends AutoDisposeStreamProvider<List<ClassSession>> {
  /// See also [sessionsByDate].
  SessionsByDateProvider(DateTime date)
    : this._internal(
        (ref) => sessionsByDate(ref as SessionsByDateRef, date),
        from: sessionsByDateProvider,
        name: r'sessionsByDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sessionsByDateHash,
        dependencies: SessionsByDateFamily._dependencies,
        allTransitiveDependencies:
            SessionsByDateFamily._allTransitiveDependencies,
        date: date,
      );

  SessionsByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<ClassSession>> Function(SessionsByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionsByDateProvider._internal(
        (ref) => create(ref as SessionsByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ClassSession>> createElement() {
    return _SessionsByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionsByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionsByDateRef on AutoDisposeStreamProviderRef<List<ClassSession>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _SessionsByDateProviderElement
    extends AutoDisposeStreamProviderElement<List<ClassSession>>
    with SessionsByDateRef {
  _SessionsByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as SessionsByDateProvider).date;
}

String _$sessionsBySubjectHash() => r'34933cbcb12dcff00b0f76609f334635c2e4e23b';

/// See also [sessionsBySubject].
@ProviderFor(sessionsBySubject)
const sessionsBySubjectProvider = SessionsBySubjectFamily();

/// See also [sessionsBySubject].
class SessionsBySubjectFamily extends Family<AsyncValue<List<ClassSession>>> {
  /// See also [sessionsBySubject].
  const SessionsBySubjectFamily();

  /// See also [sessionsBySubject].
  SessionsBySubjectProvider call(int subjectId) {
    return SessionsBySubjectProvider(subjectId);
  }

  @override
  SessionsBySubjectProvider getProviderOverride(
    covariant SessionsBySubjectProvider provider,
  ) {
    return call(provider.subjectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionsBySubjectProvider';
}

/// See also [sessionsBySubject].
class SessionsBySubjectProvider
    extends AutoDisposeStreamProvider<List<ClassSession>> {
  /// See also [sessionsBySubject].
  SessionsBySubjectProvider(int subjectId)
    : this._internal(
        (ref) => sessionsBySubject(ref as SessionsBySubjectRef, subjectId),
        from: sessionsBySubjectProvider,
        name: r'sessionsBySubjectProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sessionsBySubjectHash,
        dependencies: SessionsBySubjectFamily._dependencies,
        allTransitiveDependencies:
            SessionsBySubjectFamily._allTransitiveDependencies,
        subjectId: subjectId,
      );

  SessionsBySubjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
  }) : super.internal();

  final int subjectId;

  @override
  Override overrideWith(
    Stream<List<ClassSession>> Function(SessionsBySubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionsBySubjectProvider._internal(
        (ref) => create(ref as SessionsBySubjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ClassSession>> createElement() {
    return _SessionsBySubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionsBySubjectProvider && other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionsBySubjectRef on AutoDisposeStreamProviderRef<List<ClassSession>> {
  /// The parameter `subjectId` of this provider.
  int get subjectId;
}

class _SessionsBySubjectProviderElement
    extends AutoDisposeStreamProviderElement<List<ClassSession>>
    with SessionsBySubjectRef {
  _SessionsBySubjectProviderElement(super.provider);

  @override
  int get subjectId => (origin as SessionsBySubjectProvider).subjectId;
}

String _$presentSessionDatesHash() =>
    r'6548848e73c1f192f3c2ec9cedabb99145fedc9f';

/// See also [presentSessionDates].
@ProviderFor(presentSessionDates)
final presentSessionDatesProvider =
    AutoDisposeStreamProvider<Set<DateTime>>.internal(
      presentSessionDates,
      name: r'presentSessionDatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$presentSessionDatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PresentSessionDatesRef = AutoDisposeStreamProviderRef<Set<DateTime>>;
String _$attendanceByDateHash() => r'2295775c510b09674e8cfbc6075e76d33342f8a5';

/// Maps each date to its attendance badge type:
/// - `'present'` if at least one session was present
/// - `'absent'` if all sessions on that date were absent
/// - absent from map if no sessions or all cancelled
///
/// Copied from [attendanceByDate].
@ProviderFor(attendanceByDate)
final attendanceByDateProvider =
    AutoDisposeStreamProvider<Map<DateTime, String>>.internal(
      attendanceByDate,
      name: r'attendanceByDateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$attendanceByDateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AttendanceByDateRef =
    AutoDisposeStreamProviderRef<Map<DateTime, String>>;
String _$totalAttendanceBreakdownHash() =>
    r'9f0db7b7c317f851c990a8c395a7181086deefdd';

/// See also [totalAttendanceBreakdown].
@ProviderFor(totalAttendanceBreakdown)
final totalAttendanceBreakdownProvider =
    AutoDisposeFutureProvider<TotalBreakdown?>.internal(
      totalAttendanceBreakdown,
      name: r'totalAttendanceBreakdownProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$totalAttendanceBreakdownHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalAttendanceBreakdownRef =
    AutoDisposeFutureProviderRef<TotalBreakdown?>;
String _$attendanceStatsNotifierHash() =>
    r'92736abba9acc5604c6b24c130875f236d65994d';

abstract class _$AttendanceStatsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<AttendanceStats?> {
  late final int subjectId;

  FutureOr<AttendanceStats?> build(int subjectId);
}

/// See also [AttendanceStatsNotifier].
@ProviderFor(AttendanceStatsNotifier)
const attendanceStatsNotifierProvider = AttendanceStatsNotifierFamily();

/// See also [AttendanceStatsNotifier].
class AttendanceStatsNotifierFamily
    extends Family<AsyncValue<AttendanceStats?>> {
  /// See also [AttendanceStatsNotifier].
  const AttendanceStatsNotifierFamily();

  /// See also [AttendanceStatsNotifier].
  AttendanceStatsNotifierProvider call(int subjectId) {
    return AttendanceStatsNotifierProvider(subjectId);
  }

  @override
  AttendanceStatsNotifierProvider getProviderOverride(
    covariant AttendanceStatsNotifierProvider provider,
  ) {
    return call(provider.subjectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'attendanceStatsNotifierProvider';
}

/// See also [AttendanceStatsNotifier].
class AttendanceStatsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AttendanceStatsNotifier,
          AttendanceStats?
        > {
  /// See also [AttendanceStatsNotifier].
  AttendanceStatsNotifierProvider(int subjectId)
    : this._internal(
        () => AttendanceStatsNotifier()..subjectId = subjectId,
        from: attendanceStatsNotifierProvider,
        name: r'attendanceStatsNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$attendanceStatsNotifierHash,
        dependencies: AttendanceStatsNotifierFamily._dependencies,
        allTransitiveDependencies:
            AttendanceStatsNotifierFamily._allTransitiveDependencies,
        subjectId: subjectId,
      );

  AttendanceStatsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
  }) : super.internal();

  final int subjectId;

  @override
  FutureOr<AttendanceStats?> runNotifierBuild(
    covariant AttendanceStatsNotifier notifier,
  ) {
    return notifier.build(subjectId);
  }

  @override
  Override overrideWith(AttendanceStatsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AttendanceStatsNotifierProvider._internal(
        () => create()..subjectId = subjectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    AttendanceStatsNotifier,
    AttendanceStats?
  >
  createElement() {
    return _AttendanceStatsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceStatsNotifierProvider &&
        other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AttendanceStatsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<AttendanceStats?> {
  /// The parameter `subjectId` of this provider.
  int get subjectId;
}

class _AttendanceStatsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AttendanceStatsNotifier,
          AttendanceStats?
        >
    with AttendanceStatsNotifierRef {
  _AttendanceStatsNotifierProviderElement(super.provider);

  @override
  int get subjectId => (origin as AttendanceStatsNotifierProvider).subjectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
