import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/dio_client.dart';
import '../models/pet.dart';

part 'pet_repository.g.dart';

class PetRepository {
  final Dio _dio;

  PetRepository(this._dio);

  Future<List<Pet>> getPets({
    PetStatus? status,
    PetType? type,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/pets',
      queryParameters: {
        if (status != null) 'status': status.name.toUpperCase(),
        if (type != null) 'type': type.name.toUpperCase(),
        'limit': limit,
        'offset': offset,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Pet.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Pet> getPetById(String id) async {
    final response = await _dio.get('/pets/$id');
    return Pet.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Pet> createPet(Map<String, dynamic> petData, List<XFile> images) async {
    final List<String> directImageUrls = [];
    final List<XFile> fallbackImages = [];

    // 🚀 Layer 1 & 2: Try Direct Upload via Presigned URLs
    for (final image in images) {
      try {
        // 1. Get Presigned URL from Backend
        final presignedResponse = await _dio.get(
          '/media/presigned-url',
          queryParameters: {
            'fileName': image.name,
            'contentType': _getContentType(image.name),
          },
        );

        final String uploadUrl = presignedResponse.data['uploadUrl'];
        final String fileUrl = presignedResponse.data['fileUrl'];

        // 2. Upload directly to Cloudflare R2
        final fileBytes = await image.readAsBytes();
        final uploadResponse = await Dio().put(
          uploadUrl,
          data: Stream.fromIterable([fileBytes]),
          options: Options(
            headers: {
              'Content-Type': _getContentType(image.name),
              'Content-Length': fileBytes.length,
            },
          ),
        );

        if (uploadResponse.statusCode == 200) {
          directImageUrls.add(fileUrl);
        } else {
          fallbackImages.add(image);
        }
      } catch (e) {
        // Direct upload failed, add to fallback list
        fallbackImages.add(image);
      }
    }

    // 3. Create the Pet Post with whatever URLs we got
    final response = await _dio.post('/pets', data: {
      ...petData,
      'imageUrls': directImageUrls,
    });

    final createdPet = Pet.fromJson(response.data as Map<String, dynamic>);

    // 🧱 Layer 3: Secondary Catch-All (Backend Fallback Queue)
    if (fallbackImages.isNotEmpty) {
      for (final image in fallbackImages) {
        try {
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(image.path, filename: image.name),
            'petId': createdPet.id,
          });
          await _dio.post('/media/upload-fallback', data: formData);
        } catch (e) {
          // If even fallback fails, we log it, but the post is already created
          print('Critical: Fallback upload failed for ${image.name}');
        }
      }
    }

    return createdPet;
  }

  String _getContentType(String fileName) {
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) return 'image/jpeg';
    if (fileName.endsWith('.png')) return 'image/png';
    if (fileName.endsWith('.gif')) return 'image/gif';
    return 'application/octet-stream';
  }

  Future<Pet> updatePet(
      String id, Map<String, dynamic> petData, List<XFile> images) async {
    final List<String> directImageUrls = [];
    final List<XFile> fallbackImages = [];

    for (final image in images) {
      try {
        final presignedResponse = await _dio.get(
          '/media/presigned-url',
          queryParameters: {
            'fileName': image.name,
            'contentType': _getContentType(image.name),
          },
        );

        final String uploadUrl = presignedResponse.data['uploadUrl'];
        final String fileUrl = presignedResponse.data['fileUrl'];

        final fileBytes = await image.readAsBytes();
        await Dio().put(
          uploadUrl,
          data: Stream.fromIterable([fileBytes]),
          options: Options(
            headers: {
              'Content-Type': _getContentType(image.name),
              'Content-Length': fileBytes.length,
            },
          ),
        );

        directImageUrls.add(fileUrl);
      } catch (e) {
        fallbackImages.add(image);
      }
    }

    final response = await _dio.patch('/pets/$id', data: {
      ...petData,
      'imageUrls': directImageUrls,
    });

    final updatedPet = Pet.fromJson(response.data as Map<String, dynamic>);

    if (fallbackImages.isNotEmpty) {
      for (final image in fallbackImages) {
        try {
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(image.path, filename: image.name),
            'petId': updatedPet.id,
          });
          await _dio.post('/media/upload-fallback', data: formData);
        } catch (e) {}
      }
    }

    return updatedPet;
  }

  Future<void> deletePet(String id) async {
    await _dio.delete('/pets/$id');
  }
}

@riverpod
PetRepository petRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return PetRepository(dio);
}
