import 'dart:io';

class Environment {
  static String apiUrl = '5f3b-189-223-139-41.ngrok.io';
  static String socketUrl = Platform.isAndroid ? '192.168.0.104:3000' : 'http://localhost:3000';
}