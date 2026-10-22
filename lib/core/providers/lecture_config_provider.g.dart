// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lectureConfigDaoHash() => r'dd7b2250a21775d5b01b89cc3116ae9e4147c551';

/// See also [lectureConfigDao].
@ProviderFor(lectureConfigDao)
final lectureConfigDaoProvider = AutoDisposeProvider<LectureConfigDao>.internal(
  lectureConfigDao,
  name: r'lectureConfigDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lectureConfigDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LectureConfigDaoRef = AutoDisposeProviderRef<LectureConfigDao>;
String _$lectureConfigProviderHash() =>
    r'c434c90780551bd0789ab541fbdec35e37d54f5f';

/// See also [lectureConfigProvider].
@ProviderFor(lectureConfigProvider)
final lectureConfigProviderProvider =
    AutoDisposeStreamProvider<LectureScheduleConfigData?>.internal(
      lectureConfigProvider,
      name: r'lectureConfigProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lectureConfigProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LectureConfigProviderRef =
    AutoDisposeStreamProviderRef<LectureScheduleConfigData?>;
String _$lectureSlotsProviderHash() =>
    r'a87b8272b1ba3681fd15431e1f770827e1cc87a5';

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

/// See also [lectureSlotsProvider].
@ProviderFor(lectureSlotsProvider)
const lectureSlotsProviderProvider = LectureSlotsProviderFamily();

/// See also [lectureSlotsProvider].
class LectureSlotsProviderFamily extends Family<List<LectureSlot>> {
  /// See also [lectureSlotsProvider].
  const LectureSlotsProviderFamily();

  /// See also [lectureSlotsProvider].
  LectureSlotsProviderProvider call(int count) {
    return LectureSlotsProviderProvider(count);
  }

  @override
  LectureSlotsProviderProvider getProviderOverride(
    covariant LectureSlotsProviderProvider provider,
  ) {
    return call(provider.count);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lectureSlotsProviderProvider';
}

/// See also [lectureSlotsProvider].
class LectureSlotsProviderProvider
    extends AutoDisposeProvider<List<LectureSlot>> {
  /// See also [lectureSlotsProvider].
  LectureSlotsProviderProvider(int count)
    : this._internal(
        (ref) => lectureSlotsProvider(ref as LectureSlotsProviderRef, count),
        from: lectureSlotsProviderProvider,
        name: r'lectureSlotsProviderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$lectureSlotsProviderHash,
        dependencies: LectureSlotsProviderFamily._dependencies,
        allTransitiveDependencies:
            LectureSlotsProviderFamily._allTransitiveDependencies,
        count: count,
      );

  LectureSlotsProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.count,
  }) : super.internal();

  final int count;

  @override
  Override overrideWith(
    List<LectureSlot> Function(LectureSlotsProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LectureSlotsProviderProvider._internal(
        (ref) => create(ref as LectureSlotsProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        count: count,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<LectureSlot>> createElement() {
    return _LectureSlotsProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LectureSlotsProviderProvider && other.count == count;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, count.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LectureSlotsProviderRef on AutoDisposeProviderRef<List<LectureSlot>> {
  /// The parameter `count` of this provider.
  int get count;
}

class _LectureSlotsProviderProviderElement
    extends AutoDisposeProviderElement<List<LectureSlot>>
    with LectureSlotsProviderRef {
  _LectureSlotsProviderProviderElement(super.provider);

  @override
  int get count => (origin as LectureSlotsProviderProvider).count;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
