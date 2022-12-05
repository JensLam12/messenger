import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: Text('Espere'),
          );
        }
      )
    );
  }

  Future checkLoginState( BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLoggerIn();
    if(authenticated) {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___ ) => const UsersScreen(),
          transitionDuration: Duration(microseconds: 0)
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___ ) => const LoginScreen(),
          transitionDuration: Duration(microseconds: 0)
        )
      );
    }

  }
}