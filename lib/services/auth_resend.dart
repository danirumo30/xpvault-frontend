import 'package:http/http.dart' as http;

class AuthResend {
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
}