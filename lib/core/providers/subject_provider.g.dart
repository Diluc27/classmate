// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subjectNamesHash() => r'541ff30fd452d71c85963d9e49f3842a79200484';

/// See also [subjectNames].
@ProviderFor(subjectNames)
final subjectNamesProvider = AutoDisposeStreamProvider<List<String>>.internal(
  subjectNames,
  name: r'subjectNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subjectNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubjectNamesRef = AutoDisposeStreamProviderRef<List<String>>;
String _$getSubjectHash() => r'f265fd5e78b466a64034e6abeb47be853181e218';

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

/// See also [getSubject].
@ProviderFor(getSubject)
const getSubjectProvider = GetSubjectFamily();

/// See also [getSubject].
class GetSubjectFamily extends Family<AsyncValue<Subject?>> {
  /// See also [getSubject].
  const GetSubjectFamily();

  /// See also [getSubject].
  GetSubjectProvider call(int id) {
    return GetSubjectProvider(id);
  }

  @override
  GetSubjectProvider getProviderOverride(
    covariant GetSubjectProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getSubjectProvider';
}

/// See also [getSubject].
class GetSubjectProvider extends AutoDisposeFutureProvider<Subject?> {
  /// See also [getSubject].
  GetSubjectProvider(int id)
    : this._internal(
        (ref) => getSubject(ref as GetSubjectRef, id),
        from: getSubjectProvider,
        name: r'getSubjectProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getSubjectHash,
        dependencies: GetSubjectFamily._dependencies,
        allTransitiveDependencies: GetSubjectFamily._allTransitiveDependencies,
        id: id,
      );

  GetSubjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Subject?> Function(GetSubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSubjectProvider._internal(
        (ref) => create(ref as GetSubjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Subject?> createElement() {
    return _GetSubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSubjectProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSubjectRef on AutoDisposeFutureProviderRef<Subject?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _GetSubjectProviderElement
    extends AutoDisposeFutureProviderElement<Subject?>
    with GetSubjectRef {
  _GetSubjectProviderElement(super.provider);

  @override
  int get id => (origin as GetSubjectProvider).id;
}

String _$subjectListHash() => r'a85dad92e411802e9ae546a2325a2bb39d073b84';

/// See also [SubjectList].
@ProviderFor(SubjectList)
final subjectListProvider =
    AutoDisposeStreamNotifierProvider<SubjectList, List<Subject>>.internal(
      SubjectList.new,
      name: r'subjectListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subjectListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubjectList = AutoDisposeStreamNotifier<List<Subject>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
