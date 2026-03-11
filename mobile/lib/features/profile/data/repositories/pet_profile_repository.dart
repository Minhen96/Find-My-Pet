import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/dio_client.dart';
import '../models/pet_profile.dart';

part 'pet_profile_repository.g.dart';

class PetProfileRepository {
  final Dio _dio;

  PetProfileRepository(this._dio);

  Future<List<PetProfile>> getMyPetProfiles() async {
    final response = await _dio.get('/users/me/pets');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => PetProfile.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PetProfile> getPetProfileById(String id) async {
    final response = await _dio.get('/pets/$id');
    return PetProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PetProfile> createPetProfile(
    Map<String, dynamic> profileData,
    List<XFile> images,
  ) async {
    final List<String> imageUrls = [];

    // Simple direct upload for profiles (can be optimized later like posts)
    for (final image in images) {
      try {
        final presignedResponse = await _dio.get(
          '/media/presigned-url',
          queryParameters: {
            'fileName': image.name,
            'contentType': 'image/jpeg',
          },
        );

        final String uploadUrl = presignedResponse.data['uploadUrl'];
        final String fileUrl = presignedResponse.data['fileUrl'];

        final fileBytes = await image.readAsBytes();
        await Dio().put(uploadUrl, data: Stream.fromIterable([fileBytes]));
        imageUrls.add(fileUrl);
      } catch (e) {
        // Fallback or ignore for profiles for now
      }
    }

    final response = await _dio.post(
      '/pets',
      data: {...profileData, 'imageUrls': imageUrls},
    );

    return PetProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PetProfile> updatePetProfile(
    String id,
    Map<String, dynamic> profileData,
    List<XFile> images,
  ) async {
    final List<String> imageUrls = [];

    for (final image in images) {
      try {
        final presignedResponse = await _dio.get(
          '/media/presigned-url',
          queryParameters: {
            'fileName': image.name,
            'contentType': 'image/jpeg',
          },
        );

        final String uploadUrl = presignedResponse.data['uploadUrl'];
        final String fileUrl = presignedResponse.data['fileUrl'];

        final fileBytes = await image.readAsBytes();
        await Dio().put(uploadUrl, data: Stream.fromIterable([fileBytes]));
        imageUrls.add(fileUrl);
      } catch (e) {
        // Ignore
      }
    }

    final response = await _dio.patch(
      '/pets/$id',
      data: {...profileData, 'imageUrls': imageUrls},
    );

    return PetProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deletePetProfile(String id) async {
    await _dio.delete('/pets/$id');
  }
}

@riverpod
PetProfileRepository petProfileRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return PetProfileRepository(dio);
}
