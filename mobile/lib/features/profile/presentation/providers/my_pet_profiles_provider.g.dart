// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_pet_profiles_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyPetProfiles)
const myPetProfilesProvider = MyPetProfilesProvider._();

final class MyPetProfilesProvider
    extends $AsyncNotifierProvider<MyPetProfiles, List<PetProfile>> {
  const MyPetProfilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPetProfilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPetProfilesHash();

  @$internal
  @override
  MyPetProfiles create() => MyPetProfiles();
}

String _$myPetProfilesHash() => r'80e31e36a48d3df87a99db87b3c6a18b43730f3d';

abstract class _$MyPetProfiles extends $AsyncNotifier<List<PetProfile>> {
  FutureOr<List<PetProfile>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<PetProfile>>, List<PetProfile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PetProfile>>, List<PetProfile>>,
              AsyncValue<List<PetProfile>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
