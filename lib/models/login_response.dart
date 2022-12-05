import 'dart:convert';
import 'package:chat_app/models/users.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.ok,
    required this.userDb,
    required this.token,
  });

  bool ok;
  User userDb;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    ok: json["ok"],
    userDb: User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "userDB": userDb.toJson(),
    "token": token,
  };
}

