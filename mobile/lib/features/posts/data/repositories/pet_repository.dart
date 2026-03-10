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
    final formData = FormData.fromMap({
      ...petData,
      'images': images.isEmpty
          ? []
          : await Future.wait(
              images.map(
                (file) async => await MultipartFile.fromFile(
                  file.path,
                  filename: file.name,
                ),
              ),
            ),
    });

    final response = await _dio.post('/pets', data: formData);
    return Pet.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Pet> updatePet(
      String id, Map<String, dynamic> petData, List<XFile> images) async {
    final formData = FormData.fromMap({
      ...petData,
      if (images.isNotEmpty)
        'images': await Future.wait(
          images.map(
            (file) async => await MultipartFile.fromFile(
              file.path,
              filename: file.name,
            ),
          ),
        ),
    });

    final response = await _dio.patch('/pets/$id', data: formData);
    return Pet.fromJson(response.data as Map<String, dynamic>);
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
