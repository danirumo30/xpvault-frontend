import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthOperation {
  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/login");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password
        }),
      );
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      print("Error en el registro: $e");
    }
  }

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

  Future<void> resend(String email) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/resend");
      final res = await http.post(
        url,
        headers: {"Content-Type": "text/plain"},
        body: email,
      );
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      print("Error en el registro: $e");
    }
  }

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