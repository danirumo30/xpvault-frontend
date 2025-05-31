import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/top_user.dart';
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

  Future<List<TopUser>> getTopMovies() async {
    final url = Uri.parse("http://localhost:5000/users/top/movies");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        print("Respuesta raw películas: ${res.body}");
        final List<dynamic> data = jsonDecode(res.body);
        print("Usuarios películas recibidos: ${data.length}");
        return data.map((json) => TopUser.fromJson(json)).toList();
      } else {
        print("No se encontraron usuarios con películas top.");
      }
    } catch (e) {
      print("Error al obtener las películas top: $e");
    }

    return [];
  }

  Future<List<TopUser>> getTopTvSeries() async {
    final url = Uri.parse("http://localhost:5000/users/top/tv-series");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => TopUser.fromJson(json)).toList();
      } else {
        print("No se encontraron usuarios con series top.");
      }
    } catch (e) {
      print("Error al obtener las series top: $e");
    }

    return [];
  }

  Future<List<TopUser>> getTopGames() async {
    final url = Uri.parse("http://localhost:5000/steam-user/top");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => TopUser.fromJson(json)).toList();
      } else {
        print("No se encontraron usuarios con juegos top.");
      }
    } catch (e) {
      print("Error al obtener los juegos top: $e");
    }

    return [];
  }

  Future<User?> getUserByUsername(String username) async {
    final url = Uri.parse("http://localhost:5000/users/search?username=$username");

    try {
      final res = await http.get(url);

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final data = jsonDecode(res.body);

        if (data is List && data.isNotEmpty) {
          return User.fromJson(data[0]);
        }

        if (data is Map<String, dynamic>) {
          return User.fromJson(data);
        }

        print("Formato de datos inesperado");
      } else {
        print("Usuario no encontrado o respuesta vacía");
      }
    } catch (e) {
      print("Error al obtener usuario por username: $e");
    }

    return null;
  }
}
