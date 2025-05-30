import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/user.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';

class UserController {
  Future<void> getUser() async {
    final token = await TokenManager.getToken();
    final url = Uri.parse("http://localhost:5000/users/me");

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final res = await http.get(url, headers: headers);
      print("Guardado local: ${res.statusCode} Body: ${res.body}");
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final data = jsonDecode(res.body);
        final user = User.fromJson(data);
        print(user.toString());
        await UserManager.saveUser(user);
        print('Usuario guardado localmente: ${user.username}');
      }
    } catch (e) {
      print("Error al obtener el usuario: $e");
    }
  }

  Future<int> getSteamUserId(String steamUser) async {
    final url = Uri.parse(
      "http://localhost:5000/steam-user/resolve/id?username=$steamUser",
    );

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        UserManager.assignSteamIdToUser(res.body);
        return res.statusCode;
      }
    } catch (e) {
      throw Exception("Failed to get Steam user ID: $e");
    }

    return -1;
  }

  Future<bool> saveUser(User user, String token) async {
    final url = Uri.parse('http://localhost:5000/users/save');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    print("Soy el saveUser ${response.statusCode}");
    print(token);
    if (response.statusCode == 200) {
      print('Usuario guardado correctamente');
      return true;
    } else {
      print('Error al guardar usuario: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }
}
