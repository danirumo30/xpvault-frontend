import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/news.dart';

class GameController {
  Future<List<Game>> fetchGames({int page = 0, int size = 12}) async {
    final url = Uri.parse(
      "http://localhost:5000/game/steam/apps-with-details?page=$page&size=$size",
    );

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
        return [Game.error('ERRORXPVAULT')];
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
      return [Game.error('ERRORXPVAULT')];
    }
  }

  Future<List<Game>> searchGameByTitle({
    int page = 0,
    int size = 12,
    String gameTitle = "",
  }) async {
    final url = Uri.parse(
      "http://localhost:5000/game/steam/title/$gameTitle?page=$page&size=$size",
    );
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
        return [Game.error('ERRORXPVAULT')];
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
      return [Game.error('ERRORXPVAULT')];
    }
  }

  Future<List<Game>> getUserGames(String? steamUserId) async {
    final url = Uri.parse(
      "http://localhost:5000/steam-user/owned/$steamUserId",
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

  Future<List<Game>> getTenUserGames(String? steamUserId) async {
    final url = Uri.parse(
      "http://localhost:5000/steam-user/owned/ten/$steamUserId",
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
      "http://localhost:5000/game/steam/news/$steamGameId",
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

  Future<List<Game>> fetchFeaturedGames() async {
    final response = await http.get(Uri.parse("http://localhost:5000/game/steam/featured"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<Game?> getGameBySteamId(int steamId) async {
    final url = Uri.parse("http://localhost:5000/game/steam/details/$steamId");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Game.fromJson(data);
      } else {
        print("Error al obtener juego: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener juego: $e");
    }

    return null;
  }

  String proxiedSteamImage(String imageUrl) {
    final encodedUrl = Uri.encodeComponent(imageUrl);
    return 'http://localhost:5000/game/steam/image-proxy?url=$encodedUrl';
  }

  Future<List<Game>> getGamesByGenre({String genre = "",int page = 0, int size = 12}) async {
    final url = Uri.parse("http://localhost:5000/game/steam/genre/$genre?page=$page&size=$size");

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
        return [Game.error('ERRORXPVAULT')];
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
      return [Game.error('ERRORXPVAULT')];
    }
  }
}
