import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/dio_client.dart';
import '../models/post.dart';

part 'post_repository.g.dart';

class PostRepository {
  final Dio _dio;

  PostRepository(this._dio);

  Future<List<Post>> getPosts({
    PostType? type,
    AnimalType? animalType,
    int limit = 20,
    String? cursor,
    String? userId,
    String? petProfileId,
  }) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {
        if (type != null) 'type': type.name.toUpperCase(),
        if (animalType != null) 'animalType': animalType.name.toUpperCase(),
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
        if (userId != null) 'userId': userId,
        if (petProfileId != null) 'petProfileId': petProfileId,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Post> getPostById(String id) async {
    final response = await _dio.get('/posts/$id');
    return Post.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Post> createPost(
    Map<String, dynamic> postData,
    List<XFile> images,
  ) async {
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
        fallbackImages.add(image);
      }
    }

    final response = await _dio.post(
      '/posts',
      data: {...postData, 'imageUrls': directImageUrls},
    );

    final createdPost = Post.fromJson(response.data as Map<String, dynamic>);

    if (fallbackImages.isNotEmpty) {
      for (final image in fallbackImages) {
        try {
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            ),
            'postId': createdPost.id,
          });
          await _dio.post('/media/upload-fallback', data: formData);
        } catch (e) {
          debugPrint('Critical: Fallback upload failed for ${image.name}');
        }
      }
    }

    return createdPost;
  }

  String _getContentType(String fileName) {
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (fileName.endsWith('.png')) {
      return 'image/png';
    }
    if (fileName.endsWith('.gif')) {
      return 'image/gif';
    }
    return 'application/octet-stream';
  }

  Future<Post> updatePost(
    String id,
    Map<String, dynamic> postData,
    List<XFile> images,
  ) async {
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

    final response = await _dio.patch(
      '/posts/$id',
      data: {...postData, 'imageUrls': directImageUrls},
    );

    final updatedPost = Post.fromJson(response.data as Map<String, dynamic>);

    if (fallbackImages.isNotEmpty) {
      for (final image in fallbackImages) {
        try {
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            ),
            'postId': updatedPost.id,
          });
          await _dio.post('/media/upload-fallback', data: formData);
        } catch (_) {
          // Ignore
        }
      }
    }

    return updatedPost;
  }

  Future<void> deletePost(String id) async {
    await _dio.delete('/posts/$id');
  }
}

@riverpod
PostRepository postRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return PostRepository(dio);
}
