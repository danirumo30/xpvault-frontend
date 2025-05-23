import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/game.dart';

class GameController {
  Future<List<Game>> fetchGames({int page = 2, int size = 21}) async {
    final url = Uri.parse(
      "http://localhost:9090/game/steam/apps-with-details?page=$page&size=$size",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al obtener juegos: $e");
    }

    return [];
  }
}
