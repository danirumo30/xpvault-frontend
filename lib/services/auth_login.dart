import 'package:http/http.dart' as http;

class AuthLogin {
    Future<bool> login(String email, String password) async {
    final loginURL = Uri.parse("http://localhost:9090/login");

    final response = await http.post(
      loginURL,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: "email=$email&password=$password",
    );

    return response.statusCode == 200;
  }
}