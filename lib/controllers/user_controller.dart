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

  Future<List<User>> getAllUsers() async {
    final url = Uri.parse("http://localhost:5000/users/all");

    try {
      final res = await http.post(url);

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else if (res.statusCode == 404) {
        print("No se encontraron usuarios.");
      } else {
        print("Error inesperado: Código ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener todos los usuarios: $e");
    }

    return [];
  }
}
