import 'package:chat_app/helpers/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Logo(title: 'Registro',),
                _Form(),
                Labels( route: 'login', title: '¿Ya tienes una cuenta?', subtitle: 'Ingresa ahora', ),
                Text('Terminos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ) )
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    
    return Container(
      margin: const EdgeInsets.only( top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passwordCtrl,
            isPassword: true,
          ),
          BlueButton(
            text: 'Crear cuenta', 
            onPressed: ( authService.authentic)  ? null : () async {
              FocusScope.of(context).unfocus();
              final response = await authService.registerUser( nameCtrl.text.trim(), emailCtrl.text.trim(), passwordCtrl.text.trim() );
              if(response == true) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                showAlert(context, 'Error en registro', response);
              }
            } 
          )
        ],
      ),
    );
  }
}