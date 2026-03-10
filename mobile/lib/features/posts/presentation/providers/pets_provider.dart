import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/pet.dart';
import '../data/repositories/pet_repository.dart';

part 'pets_provider.g.dart';

@riverpod
class Pets extends _$Pets {
  @override
  FutureOr<List<Pet>> build() async {
    return _fetchPets();
  }

  Future<List<Pet>> _fetchPets({PetStatus? status, PetType? type}) async {
    final repository = ref.read(petRepositoryProvider);
    return await repository.getPets(status: status, type: type);
  }

  Future<void> createPet(Map<String, dynamic> petData, List<XFile> images) async {
    final repository = ref.read(petRepositoryProvider);
    await repository.createPet(petData, images);
    await refresh();
  }

  Future<void> updatePet(String id, Map<String, dynamic> petData, List<XFile> images) async {
    final repository = ref.read(petRepositoryProvider);
    await repository.updatePet(id, petData, images);
    await refresh();
  }

  Future<void> deletePet(String id) async {
    final repository = ref.read(petRepositoryProvider);
    await repository.deletePet(id);
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPets());
  }
}
