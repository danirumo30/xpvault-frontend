import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/user.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';

class UserController {
  Future<void> getUser() async {
    final token = await TokenManager.getToken();
    final url = Uri.parse("https://corsproxy.io/http://spring-env.eba-mwisafe4.eu-west-1.elasticbeanstalk.com/users/me");

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final data = jsonDecode(res.body);
        final user = User.fromJson(data);
        await UserManager.saveUser(user);
        print('Usuario guardado localmente: ${user.username}');
      }
    } catch (e) {
      print("Error al obtener el usuario: $e");
    }
  }

  Future<int> getSteamUserId(String steamUser) async {
    final url = Uri.parse(
      "https://corsproxy.io/http://spring-env.eba-mwisafe4.eu-west-1.elasticbeanstalk.com/steam-user/resolve/id?username=$steamUser",
    );

    try {
    final res = await http.get(url);

    if (res.statusCode == 200) {
      UserManager.assignSteamIdToUser(int.parse(res.body));
      return res.statusCode;
    } 

    } catch (e) {
      throw Exception("Failed to get Steam user ID: $e");
    }

    return -1;
  }
}
