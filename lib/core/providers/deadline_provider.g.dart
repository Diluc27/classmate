// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deadline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deadlineListHash() => r'bcfb27eafbb66476e41ff487908e5a093076b120';

/// See also [deadlineList].
@ProviderFor(deadlineList)
final deadlineListProvider = AutoDisposeStreamProvider<List<Deadline>>.internal(
  deadlineList,
  name: r'deadlineListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deadlineListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeadlineListRef = AutoDisposeStreamProviderRef<List<Deadline>>;
String _$upcomingDeadlinesHash() => r'0d89e587caa4253a1fadaba5fdbbed0abe2c2c15';

/// See also [upcomingDeadlines].
@ProviderFor(upcomingDeadlines)
final upcomingDeadlinesProvider =
    AutoDisposeStreamProvider<List<Deadline>>.internal(
      upcomingDeadlines,
      name: r'upcomingDeadlinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$upcomingDeadlinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingDeadlinesRef = AutoDisposeStreamProviderRef<List<Deadline>>;
String _$deadlinesBySubjectHash() =>
    r'a92017d675f775c789be57eb40410f815fff1890';

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

/// See also [deadlinesBySubject].
@ProviderFor(deadlinesBySubject)
const deadlinesBySubjectProvider = DeadlinesBySubjectFamily();

/// See also [deadlinesBySubject].
class DeadlinesBySubjectFamily extends Family<AsyncValue<List<Deadline>>> {
  /// See also [deadlinesBySubject].
  const DeadlinesBySubjectFamily();

  /// See also [deadlinesBySubject].
  DeadlinesBySubjectProvider call(int subjectId) {
    return DeadlinesBySubjectProvider(subjectId);
  }

  @override
  DeadlinesBySubjectProvider getProviderOverride(
    covariant DeadlinesBySubjectProvider provider,
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
  String? get name => r'deadlinesBySubjectProvider';
}

/// See also [deadlinesBySubject].
class DeadlinesBySubjectProvider
    extends AutoDisposeStreamProvider<List<Deadline>> {
  /// See also [deadlinesBySubject].
  DeadlinesBySubjectProvider(int subjectId)
    : this._internal(
        (ref) => deadlinesBySubject(ref as DeadlinesBySubjectRef, subjectId),
        from: deadlinesBySubjectProvider,
        name: r'deadlinesBySubjectProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deadlinesBySubjectHash,
        dependencies: DeadlinesBySubjectFamily._dependencies,
        allTransitiveDependencies:
            DeadlinesBySubjectFamily._allTransitiveDependencies,
        subjectId: subjectId,
      );

  DeadlinesBySubjectProvider._internal(
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
    Stream<List<Deadline>> Function(DeadlinesBySubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeadlinesBySubjectProvider._internal(
        (ref) => create(ref as DeadlinesBySubjectRef),
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
  AutoDisposeStreamProviderElement<List<Deadline>> createElement() {
    return _DeadlinesBySubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeadlinesBySubjectProvider && other.subjectId == subjectId;
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
mixin DeadlinesBySubjectRef on AutoDisposeStreamProviderRef<List<Deadline>> {
  /// The parameter `subjectId` of this provider.
  int get subjectId;
}

class _DeadlinesBySubjectProviderElement
    extends AutoDisposeStreamProviderElement<List<Deadline>>
    with DeadlinesBySubjectRef {
  _DeadlinesBySubjectProviderElement(super.provider);

  @override
  int get subjectId => (origin as DeadlinesBySubjectProvider).subjectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
