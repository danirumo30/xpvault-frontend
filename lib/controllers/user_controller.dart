import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/basic_user.dart';
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

  Future<List<BasicUser>> getAllUsers() async {
    final url = Uri.parse("http://localhost:5000/users/all");

    try {
      final res = await http.post(url);

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => BasicUser.fromJson(json)).toList();
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

  Future<List<BasicUser>> fetchUserFriends(String appUsername) async {
    final url = "http://localhost:5000/users/profile/$appUsername/friends";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => BasicUser.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> addFriend(String username, String friendUsername) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
      "http://localhost:5000/users/$username/friends/add?friendUsername=$friendUsername",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Amigo agregado correctamente: $friendUsername');
        return true;
      } else {
        print('Error al agregar amigo: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Excepción al agregar amigo: $e');
      return false;
    }
  }

  Future<bool> deleteFriendFromUser(String username, String friendUsername) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
        "http://localhost:5000/users/$username/friends/delete?friendUsername=$friendUsername"
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Amigo eliminado correctamente: $friendUsername');
        return true;
      } else {
        print('Error al eliminar amigo: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Excepción al eliminar amigo: $e');
      return false;
    }
  }

  Future<bool> isFriend(String username, String friendUsername) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
        "http://localhost:5000/users/$username/friends/is-friend?friendUsername=$friendUsername"
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['isFriend'] ?? false;
      } else {
        print('Error al verificar amistad: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Excepción al verificar amistad: $e');
      return false;
    }
  }

  Future<bool> deleteMovieFromUser(String username, int movieId) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
      "http://localhost:5000/users/$username/movies/delete?movieId=$movieId",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Película eliminada correctamente.");
        return true;
      } else {
        print("Error al eliminar película: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Excepción al eliminar película: $e");
    }
    return false;
  }

  Future<bool> deleteTvSerieFromUser(String username, int tvSerieId) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
      "http://localhost:5000/users/$username/tv-series/delete?tvSerieId=$tvSerieId",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Serie eliminada correctamente.");
        return true;
      } else {
        print("Error al eliminar serie: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Excepción al eliminar serie: $e");
    }
    return false;
  }

  Future<bool> isMovieAdded(String username, int movieId) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
      "http://localhost:5000/users/$username/movies/is-added?movieId=$movieId",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["isMovieAdded"] ?? false;
      } else {
        print("Error al comprobar si la película está añadida: ${response.statusCode}");
      }
    } catch (e) {
      print("Excepción al comprobar si la película está añadida: $e");
    }
    return false;
  }

  Future<bool> isTvSerieAdded(String username, int tvSerieId) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse(
      "http://localhost:5000/users/$username/tv-series/is-added?tvSerieId=$tvSerieId",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["isTvSerieAdded"] ?? false;
      } else {
        print("Error al comprobar si la serie está añadida: ${response.statusCode}");
      }
    } catch (e) {
      print("Excepción al comprobar si la serie está añadida: $e");
    }
    return false;
  }

  Future<bool> addMovieToUser(String username, int movieId, {String language = "en"}) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse("http://localhost:5000/users/$username/movies/add?movieId=$movieId");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept-Language': language,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Película añadida correctamente.");
        return true;
      } else {
        print("Error al añadir película: ${response.statusCode}");
        print(response.body);
        return false;
      }
    } catch (e) {
      print("Excepción al añadir película: $e");
      return false;
    }
  }

  Future<bool> addTvSerieToUser(String username, int tvSerieId, {String language = "en"}) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse("http://localhost:5000/users/$username/tv-series/add?tvSerieId=$tvSerieId");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept-Language': language,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Serie añadida correctamente.");
        return true;
      } else {
        print("Error al añadir serie: ${response.statusCode}");
        print(response.body);
        return false;
      }
    } catch (e) {
      print("Excepción al añadir serie: $e");
      return false;
    }
  }
}
