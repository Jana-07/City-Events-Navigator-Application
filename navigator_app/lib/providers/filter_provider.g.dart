// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventFiltersHash() => r'558693a2d956414880a63fef99f5011713624dde';

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

abstract class _$EventFilters extends BuildlessNotifier<EventFilter> {
  late final String listId;

  EventFilter build(
    String listId,
  );
}

/// See also [EventFilters].
@ProviderFor(EventFilters)
const eventFiltersProvider = EventFiltersFamily();

/// See also [EventFilters].
class EventFiltersFamily extends Family<EventFilter> {
  /// See also [EventFilters].
  const EventFiltersFamily();

  /// See also [EventFilters].
  EventFiltersProvider call(
    String listId,
  ) {
    return EventFiltersProvider(
      listId,
    );
  }

  @override
  EventFiltersProvider getProviderOverride(
    covariant EventFiltersProvider provider,
  ) {
    return call(
      provider.listId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'eventFiltersProvider';
}

/// See also [EventFilters].
class EventFiltersProvider
    extends NotifierProviderImpl<EventFilters, EventFilter> {
  /// See also [EventFilters].
  EventFiltersProvider(
    String listId,
  ) : this._internal(
          () => EventFilters()..listId = listId,
          from: eventFiltersProvider,
          name: r'eventFiltersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventFiltersHash,
          dependencies: EventFiltersFamily._dependencies,
          allTransitiveDependencies:
              EventFiltersFamily._allTransitiveDependencies,
          listId: listId,
        );

  EventFiltersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
  }) : super.internal();

  final String listId;

  @override
  EventFilter runNotifierBuild(
    covariant EventFilters notifier,
  ) {
    return notifier.build(
      listId,
    );
  }

  @override
  Override overrideWith(EventFilters Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventFiltersProvider._internal(
        () => create()..listId = listId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
      ),
    );
  }

  @override
  NotifierProviderElement<EventFilters, EventFilter> createElement() {
    return _EventFiltersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventFiltersProvider && other.listId == listId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventFiltersRef on NotifierProviderRef<EventFilter> {
  /// The parameter `listId` of this provider.
  String get listId;
}

class _EventFiltersProviderElement
    extends NotifierProviderElement<EventFilters, EventFilter>
    with EventFiltersRef {
  _EventFiltersProviderElement(super.provider);

  @override
  String get listId => (origin as EventFiltersProvider).listId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
