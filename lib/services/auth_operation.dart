import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthOperation {
  Future<int> login(String email, String password) async {
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
      return res.statusCode;
    } catch (e) {
      print("Error en el registro: $e");
    }
    return -1;
  }

  Future<int> signup(String email, String password) async {
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
      return res.statusCode;
    } catch (e) {
      print("Error en el registro: $e");
    }
    return -1;
  }

  Future<int> resend(String email) async {
    try {
      final url = Uri.parse("http://localhost:9090/auth/resend");
      final res = await http.post(
        url,
        headers: {"Content-Type": "text/plain"},
        body: email,
      );
      return res.statusCode;
    } catch (e) {
      print("Error en el registro: $e");
    }
    return -1;
  }

  Future<int> verifyCode(String email, String code) async {
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
      return res.statusCode;
    } catch (e) {
      print("Error en el registro: $e");
    }
    return -1;
  }
}