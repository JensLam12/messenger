import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/users.dart';
import '../globals/environment.dart';

class AuthService with ChangeNotifier{

  late User user;
  bool _authentic = false;
  bool get authentic => _authentic;
  // Create storage
  static FlutterSecureStorage _storage = FlutterSecureStorage();

  set authentic(bool value) {
    _authentic = value;
    notifyListeners();
  }

  static Future<String?> getToken() async{
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future deleteToken() async{
    await _storage.delete(key: 'token');
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  
  Future<bool> login( String email, String password) async {
    authentic = true;
    final url = Uri.https( Environment.apiUrl, '/api/login');

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post( url,
      body: jsonEncode(data),
      headers: { 'Content-Type': 'application/json' } 
    ).catchError((onError) {
      print(onError); 
      //return null;
    });

    authentic = false;
    if( resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.userDb;
      await _saveToken(loginResponse.token);
      return true;
    }
    else {
      return false;
    }
  }

  Future registerUser(String name, String email, String password) async {
    authentic = true;
    final url = Uri.https( Environment.apiUrl, '/api/login/addUser');

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final resp = await http.post( url,
      body: jsonEncode(data),
      headers: { 'Content-Type': 'application/json' } 
    );

    authentic = false;
    if( resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.userDb;
      await _saveToken(loginResponse.token);
      return true;
    }
    else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggerIn() async {
    final token = await _storage.read(key: 'token');
    final url = Uri.https( Environment.apiUrl, '/api/login/renew');

    final resp = await http.get( url,
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token != null ? token.toString() : '' 
      } 
    );

    if( resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.userDb;
      await _saveToken(loginResponse.token);
      return true;
    }
    else {
      logout();
      return false;
    }
  }

  Future _saveToken(String token ) async {
    return await _storage.write(key: 'token', value: token );
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}