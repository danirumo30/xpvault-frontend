import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/news.dart';

class GameController {
  Future<List<Game>> fetchGames({int page = 0, int size = 12}) async {
    final url = Uri.parse(
      "https://www.xpvaultbackend.es/game/steam/apps-with-details?page=$page&size=$size",
    );

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
    }

    return [];
  }

  Future<List<Game>> searchGameByTitle({
    int page = 0,
    int size = 12,
    String gameTitle = "",
  }) async {
    final url = Uri.parse(
      "https://www.xpvaultbackend.es/game/steam/title/$gameTitle?page=$page&size=$size",
    );

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
    }

    return [];
  }

  Future<List<Game>> getUserGames(int? steamUserId) async {
    final url = Uri.parse(
      "https://www.xpvaultbackend.es/steam-user/owned/$steamUserId",
    );

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        return data
            .where((json) => json['game'] != null)
            .map<Game>((json) => Game.fromJson(json['game']))
            .toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
    }

    return [];
  }

  Future<List<News>> getGameNewsById(int steamGameId) async {
    final url = Uri.parse(
      "https://www.xpvaultbackend.es/game/steam/news/$steamGameId",
    );

    try {
      final res = await http.get(url);
      print(steamGameId);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => News.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
    }

    return [];
  }
}
