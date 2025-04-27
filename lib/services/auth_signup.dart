import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthSignup {
  Future<void> signup(String email, String password) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/signup");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
          "username": email.substring(0,email.indexOf('@')),
        }),
      );
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      print("Error en el registro: $e");
    }
  }
}