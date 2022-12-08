import 'dart:io';

class Environment {
  static String apiUrl = 'a431-189-223-139-41.ngrok.io';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.0.104:3000' : 'http://localhost:3000';
}