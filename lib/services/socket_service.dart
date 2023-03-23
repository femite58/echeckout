import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService() {
    const String url = 'http://socket.pavypay.com';
    socket = IO.io(url, IO.OptionBuilder().setTransports(['websocket']).build());
  }
  static late IO.Socket socket;
}
