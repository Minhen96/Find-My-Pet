class AppConstants {
  static const wsEvents = _WsEvents();
}

class _WsEvents {
  const _WsEvents();
  final String joinPet = 'joinPet';
  final String leavePet = 'leavePet';
  final String likeUpdate = 'likeUpdate';
  final String newComment = 'newComment';
}
