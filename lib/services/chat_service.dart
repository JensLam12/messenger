import 'package:chat_app/models/message_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../globals/environment.dart';
import '../models/users.dart';
import 'auth_service.dart';

class ChatService with ChangeNotifier {
  late User usertTo;

  Future<List<Message>> getChat(String userId) async {
    final url = Uri.https( Environment.apiUrl, '/api/messages/$userId');
    final token = await AuthService.getToken();

    final resp = await http.get( url,
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token ?? '' 
      } 
    );

    final messageResponse = messageResponseFromJson( resp.body);
    return messageResponse.messages;
  }
}