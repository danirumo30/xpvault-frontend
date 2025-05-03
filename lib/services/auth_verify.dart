import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthVerify {
  Future<void> verifyCode(String email, String code) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/verify");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "verificationCode": code
        }),
      );
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      print("Error en el registro: $e");
    }
  }
}