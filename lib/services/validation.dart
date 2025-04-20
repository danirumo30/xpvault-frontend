import 'package:flutter/material.dart';
import 'package:game_trackr/pages/home.dart';

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

  static bool submitForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return true;
    }
    return false;
  }
}
