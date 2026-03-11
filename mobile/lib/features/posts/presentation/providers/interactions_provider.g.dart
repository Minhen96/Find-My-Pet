// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Interactions)
const interactionsProvider = InteractionsFamily._();

final class InteractionsProvider
    extends $AsyncNotifierProvider<Interactions, Map<String, dynamic>> {
  const InteractionsProvider._({
    required InteractionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'interactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$interactionsHash();

  @override
  String toString() {
    return r'interactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Interactions create() => Interactions();

  @override
  bool operator ==(Object other) {
    return other is InteractionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$interactionsHash() => r'f6b9a00519658765c5a5b48814eefd765c94e74c';

final class InteractionsFamily extends $Family
    with
        $ClassFamilyOverride<
          Interactions,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>,
          String
        > {
  const InteractionsFamily._()
    : super(
        retry: null,
        name: r'interactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InteractionsProvider call(String postId) =>
      InteractionsProvider._(argument: postId, from: this);

  @override
  String toString() => r'interactionsProvider';
}

abstract class _$Interactions extends $AsyncNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<Map<String, dynamic>> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
