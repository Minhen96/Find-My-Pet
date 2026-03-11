import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/features/posts/data/models/post.dart';
import 'package:mobile/features/posts/data/repositories/post_repository.dart';

part 'posts_provider.g.dart';

@riverpod
class Posts extends _$Posts {
  @override
  FutureOr<List<Post>> build() async {
    return _fetchPosts();
  }

  Future<List<Post>> _fetchPosts({PostType? type, AnimalType? animalType}) async {
    final repository = ref.read(postRepositoryProvider);
    return await repository.getPosts(type: type, animalType: animalType);
  }

  Future<void> createPost(
    Map<String, dynamic> postData,
    List<XFile> images,
  ) async {
    final repository = ref.read(postRepositoryProvider);
    await repository.createPost(postData, images);
    await refresh();
  }

  Future<void> updatePost(
    String id,
    Map<String, dynamic> postData,
    List<XFile> images,
  ) async {
    final repository = ref.read(postRepositoryProvider);
    await repository.updatePost(id, postData, images);
    await refresh();
  }

  Future<void> deletePost(String id) async {
    final repository = ref.read(postRepositoryProvider);
    await repository.deletePost(id);
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPosts());
  }
}
