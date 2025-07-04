import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utils/logger/app_logger.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;
  late IO.Socket socket;

  SocketService._internal();

  void connect({required String userId, required String userType}) {
    AppLogger.i("🚀 Attempting to connect to socket...");

    socket = IO.io('http://192.168.0.109:4000', {
      // change if on emulator
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    AppLogger.i("⏳ Connecting...");

    socket.on('new-ride', (data) {
      AppLogger.i("New Ride Message");
    });

    socket.onConnect((_) {
      AppLogger.i("✅ Connected: ${socket.id}");

      socket.emit('join', {'userId': userId, 'userType': userType});
    });

    socket.onConnectError((data) {
      AppLogger.i("❌ Connect error: $data");
    });

    socket.onError((data) {
      AppLogger.i("❌ General socket error: $data");
    });

    socket.onDisconnect((_) {
      AppLogger.i("🔌 Disconnected from server");
    });

    socket.onReconnect((_) {
      AppLogger.i("🔄 Reconnected");
      socket.emit('join', {'userId': userId, 'userType': userType});
    });

    /*socket.on((data) {
      AppLogger.i("🚗 Captain location updated: $data");
      socket.emit('update-location-captain', data);
    });*/
  }

  void emit(String event, dynamic data) {
    if (socket.connected) {
      AppLogger.i("📤 Emitting $event: $data");
      socket.emit(event, data);
    } else {
      AppLogger.i("⚠️ Cannot emit $event. Socket not connected.");
    }
  }
}
