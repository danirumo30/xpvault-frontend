import 'package:flutter/material.dart';
import 'package:game_trackr/pages/home.dart';
import 'package:game_trackr/pages/verify_resend.dart';

class ValidationService {
  static String? emailValidation(String? email) {
    if (email == null ||
        !RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
        ).hasMatch(email)) {
      return "El correo indicado no es válido";
    }
    return null;
  }

  static String? passwordValidation(String? password) {
    if (password == null) {
      return "Introduzca una contraseña";
    } else if (password.length < 6 ||
        !RegExp(r'^(?=.*[!@#\$%\^])').hasMatch(password)) {
      return "Mínimo 6 caracteres y al menos uno especial entre estos !@#\$%^";
    }
    return null;
  }

  static bool submitForm(GlobalKey<FormState> formKey, BuildContext context, String email) {
    if (formKey.currentState?.validate() ?? false) {
      if (email.isNotEmpty) {
        // Si el argumento del email no está vacío quiere decir que está registrandose
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyResendPage(emailRegistration: email,)),
        );
      } else {
        // Si el argumento del email está vacío quiere decir que inicia sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }

      return true;
    }
    return false;
  }

  static String? verifyCodeLength(String? code) {
    if (code == null) {
      return "Introduzca el código indicado en el correo";
    } else if (code.length < 6 || !RegExp(r'^\d+$').hasMatch(code)) {
      return "El código indicado no es válido";
    }
    return null;
  }
}
