import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthLogin {
  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/login");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      print("Error en el registro: $e");
    }
  }
}