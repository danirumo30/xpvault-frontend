import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:xpvault/models/movie.dart';

class MovieController {
  List<Movie> _allMovies = [];

  // Cargar películas desde un JSON local (puedes adaptar para API)
  Future<void> loadMoviesFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    _allMovies = jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  // Obtener películas paginadas (page empieza en 1)
  List<Movie> fetchMovies({int page = 1, int size = 10}) {
    final startIndex = (page - 1) * size;
    final endIndex = startIndex + size;
    if (startIndex >= _allMovies.length) {
      return [];
    }
    return _allMovies.sublist(
      startIndex,
      endIndex > _allMovies.length ? _allMovies.length : endIndex,
    );
  }

  // Buscar películas por título (paginado)
  List<Movie> searchMovieByTitle({
    required String title,
    int page = 1,
    int size = 10,
  }) {
    final filtered = _allMovies
        .where((movie) => movie.title.toLowerCase().contains(title.toLowerCase()))
        .toList();

    final startIndex = (page - 1) * size;
    final endIndex = startIndex + size;
    if (startIndex >= filtered.length) {
      return [];
    }
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }
}
