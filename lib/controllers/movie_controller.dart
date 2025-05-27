import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieController {
  Future<List<Movie>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse("https://www.xpvaultbackend.es/movies/popular?page=0"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Movie>> fetchUserMovies(String appUsername) async {
    final url = "https://www.xpvaultbackend.es/users/profile/$appUsername/movies";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
