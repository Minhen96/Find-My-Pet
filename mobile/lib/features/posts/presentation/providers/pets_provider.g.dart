// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Pets)
const petsProvider = PetsProvider._();

final class PetsProvider extends $AsyncNotifierProvider<Pets, List<Pet>> {
  const PetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'petsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$petsHash();

  @$internal
  @override
  Pets create() => Pets();
}

String _$petsHash() => r'1a21e39291a57a98f68c8bf24c3fa68f7edfdcad';

abstract class _$Pets extends $AsyncNotifier<List<Pet>> {
  FutureOr<List<Pet>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Pet>>, List<Pet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Pet>>, List<Pet>>,
              AsyncValue<List<Pet>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
