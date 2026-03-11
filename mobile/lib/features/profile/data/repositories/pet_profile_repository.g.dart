// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(petProfileRepository)
const petProfileRepositoryProvider = PetProfileRepositoryProvider._();

final class PetProfileRepositoryProvider
    extends
        $FunctionalProvider<
          PetProfileRepository,
          PetProfileRepository,
          PetProfileRepository
        >
    with $Provider<PetProfileRepository> {
  const PetProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'petProfileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$petProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<PetProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PetProfileRepository create(Ref ref) {
    return petProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PetProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PetProfileRepository>(value),
    );
  }
}

String _$petProfileRepositoryHash() =>
    r'adf2220f6fe60ded1b1c4170c0ff87128f6f460d';
