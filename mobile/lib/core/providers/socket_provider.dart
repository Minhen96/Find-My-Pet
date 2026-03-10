import '../api/api_constants.dart';

part 'socket_provider.g.dart';

@riverpod
IO.Socket socket(Ref ref) {
  final socket = IO.io(ApiConstants.socketUrl, 
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build()
  );

  socket.connect();

  ref.onDispose(() {
    socket.dispose();
  });

  return socket;
}
