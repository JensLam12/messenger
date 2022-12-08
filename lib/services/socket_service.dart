import 'package:chat_app/globals/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {
  late IO.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.connecting;
  get serverStatus => _serverStatus;
  get socket => _socket;
  get emit => _socket.emit;

  void connect() async {

    final token = await AuthService.getToken();

    _socket = IO.io( Environment.socketUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .enableAutoConnect()
      .enableForceNew()
      .setExtraHeaders({ 'x-token': token })
      .build()
    );

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect( (_) { 
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('new-message', (payload) { 
    //   print( 'new-message: $payload');
    //   // print(payload.containsKey('message2') ? payload['message2'] : 'No hay');
    // });
  }

  void disconnect() {
    try {
      _socket.disconnect();
    }catch( _ ) {

    }
  }
  
}