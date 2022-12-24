import 'dart:io';

class Environment {
  static String apiUrl = '146f-201-171-157-211.ngrok.io';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.0.107:3000' : 'http://localhost:3000';
}