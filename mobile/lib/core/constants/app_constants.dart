class AppConstants {
  static const wsEvents = _WsEvents();
}

class _WsEvents {
  const _WsEvents();
  final String joinPost = 'joinPost';
  final String leavePost = 'leavePost';
  final String likeUpdate = 'likeUpdate';
  final String newComment = 'newComment';
}
