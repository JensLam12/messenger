import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/users.dart';
import '../globals/environment.dart';

class UsersServices {
  Future<List<User>> getUsers() async {
    try {
      final url = Uri.https( Environment.apiUrl, '/api/users');
      final token = await AuthService.getToken();

      final resp = await http.get( url,
        headers: { 
          'Content-Type': 'application/json',
          'x-token': token ?? '' 
        } 
      );

      final userResponse = usersResponseFromJson( resp.body);
      return userResponse.users;

    }catch(exception) {
      return [];
    }
  }
}