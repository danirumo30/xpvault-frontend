import 'package:http/http.dart' as http;

class AuthSignup {
    Future<bool> singup(String email, String password) async {
    final singupURL = Uri.parse("http://localhost:9090/singup");

    final response = await http.post(
      singupURL,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: "email=$email&password=$password",
    );

    return response.statusCode == 200;
  }
}