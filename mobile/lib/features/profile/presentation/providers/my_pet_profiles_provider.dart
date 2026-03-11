import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/features/profile/data/models/pet_profile.dart';
import 'package:mobile/features/profile/data/repositories/pet_profile_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

part 'my_pet_profiles_provider.g.dart';

@riverpod
class MyPetProfiles extends _$MyPetProfiles {
  @override
  FutureOr<List<PetProfile>> build() async {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    
    if (user == null) {
      return [];
    }
    
    final repository = ref.read(petProfileRepositoryProvider);
    return await repository.getMyPetProfiles();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authProvider).value;
      if (user == null) return [];
      final repository = ref.read(petProfileRepositoryProvider);
      return await repository.getMyPetProfiles();
    });
  }
}
