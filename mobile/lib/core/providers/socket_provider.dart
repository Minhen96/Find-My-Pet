import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../api/api_constants.dart';

part 'socket_provider.g.dart';

@riverpod
io.Socket socket(Ref ref) {
  final socket = io.io(
    ApiConstants.socketUrl,
    io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );

  socket.connect();

  ref.onDispose(() {
    socket.dispose();
  });

  return socket;
}
