import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xpvault/models/movie.dart';
import 'package:flutter/services.dart';

class MovieController {
  final String _baseUrl = "http://localhost:5000/movies";

  Future<void> loadMoviesFromAssets(String path) async {
    try {
      final String response = await rootBundle.loadString('assets/$path');
      final List data = jsonDecode(response);
      print("Películas cargadas desde assets: ${data.length}");
    } catch (e) {
      print("Error al cargar películas desde assets: $e");
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 0}) async {
    final url = Uri.parse("$_baseUrl/popular?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener películas populares: $e");
    }

    return [];
  }

  Future<List<Movie>> getTopRatedMovies({int page = 0}) async {
    final url = Uri.parse("$_baseUrl/top-rated?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener películas top-rated: $e");
    }

    return [];
  }

  Future<List<Movie>> getUpcomingMovies({int page = 0}) async {
    final url = Uri.parse("$_baseUrl/upcoming?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener películas próximas: $e");
    }

    return [];
  }

  Future<List<Movie>> searchMovieByTitle(String movieName, {int page = 0}) async {
    final url = Uri.parse("$_baseUrl/title/$movieName?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al buscar película por título: $e");
    }

    return [];
  }

  Future<Movie?> getMovieById(String movieId, {int page = 0}) async {
    final url = Uri.parse("$_baseUrl/id/$movieId?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Movie.fromJson(data);
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener película por ID: $e");
    }

    return null;
  }

  Future<Movie?> getFullMovieById(String movieId, {int page = 0}) async {
    final url = Uri.parse("$_baseUrl/id/full/$movieId?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Movie.fromJson(data);
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener detalles completos de la película: $e");
    }

    return null;
  }

  Future<List<Movie>> getMoviesByGenre(String genre, {int page = 1}) async {
    final url = Uri.parse("$_baseUrl/genre/$genre?page=$page");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error al obtener películas por género: $e");
    }

    return [];
  }

  Future<List<Movie>> fetchUserMovies(String appUsername) async {
    final url = "http://localhost:5000/users/profile/$appUsername/movies";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
