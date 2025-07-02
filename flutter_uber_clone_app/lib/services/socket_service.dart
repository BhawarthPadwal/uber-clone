import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utils/logger/app_logger.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;
  late IO.Socket socket;

  SocketService._internal();

  void connect({required String userId, required String userType}) {
    AppLogger.i("🚀 Attempting to connect to socket...");

    socket = IO.io('http://192.168.0.116:4000', {
      // change if on emulator
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    AppLogger.i("⏳ Connecting...");

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
  }

  /*void connect({required String userId, required String userType}) {
    socket = IO.io('http://192.168.0.116:4000', {
      'transports': ['websocket'],
      'autoConnect': false,
    });


    socket.connect();

    socket.onConnect((_) {
      print("Connected: ${socket.id}");

      // Join socket
      socket.emit('join', {
        'userId': userId,
        'userType': userType, // 'user' or 'captain'
      });
    });

    socket.onDisconnect((_) {
      print("Disconnected");
    });

    // Example listener
    socket.on('new-ride', (data) {
      print("🚖 New Ride Request: $data");
      // show a dialog or handle in bloc
    });

    socket.on('ride-confirmed', (data) {
      print("✅ Ride confirmed: $data");
    });

    socket.on('ride-started', (data) {
      print("🏁 Ride started: $data");
    });

    socket.on('ride-completed', (data) {
      print("🛑 Ride completed: $data");
    });
  }

  void updateLocation(String captainId, Map<String, dynamic> location) {
    socket.emit('update-location-captain', {
      'userId': captainId,
      'location': location,
    });
  }

  void disconnect() {
    socket.disconnect();
  }*/
}
