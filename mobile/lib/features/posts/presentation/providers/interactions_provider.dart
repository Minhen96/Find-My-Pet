import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/socket_provider.dart';

part 'interactions_provider.g.dart';

@riverpod
class Interactions extends _$Interactions {
  @override
  FutureOr<Map<String, dynamic>> build(String petId) async {
    final socket = ref.watch(socketProvider);
    
    // Listen for real-time updates
    socket.on(AppConstants.wsEvents.likeUpdate, (data) {
      if (data['newCount'] != null) {
        state = AsyncData({
          ...state.value ?? {},
          'likesCount': data['newCount'],
        });
      }
    });

    socket.on(AppConstants.wsEvents.newComment, (data) {
      final currentComments = List<dynamic>.from(state.value?['comments'] ?? []);
      state = AsyncData({
        ...state.value ?? {},
        'comments': [data, ...currentComments],
      });
    });

    return _fetchInteractions(petId);
  }

  Future<Map<String, dynamic>> _fetchInteractions(String petId) async {
    final dio = ref.read(dioClientProvider);
    final response = await dio.get('/pets/$petId/interactions');
    return response.data as Map<String, dynamic>;
  }

  Future<void> toggleLike() async {
    final dio = ref.read(dioClientProvider);
    await dio.post('/pets/$petId/interactions/like');
    ref.invalidateSelf();
  }

  Future<void> addComment(String content) async {
    final dio = ref.read(dioClientProvider);
    await dio.post(
      '/pets/$petId/interactions/comment',
      data: {'content': content},
    );
    ref.invalidateSelf();
  }
}
