import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthSignup {
  Future<void> signup(String email, String password) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/signup");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
          "username": "UsuarioDemo", // puedes cambiarlo según tus necesidades
        }),
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
    } catch (e) {
      print("Error en el registro: $e");
    }
  }
}
