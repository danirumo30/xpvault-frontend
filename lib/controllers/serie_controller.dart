import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/serie.dart';

class SerieController {
  final String _baseUrl = "http://localhost:5000/tv-series";

  Future<List<Serie>> fetchPopularSeries({int page = 1}) async {
    final response = await http.get(Uri.parse("$_baseUrl/popular?page=$page"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Serie.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Serie>> fetchFullPopularSeries({int page = 1}) async {
    print(page);
    final response = await http.get(Uri.parse("$_baseUrl/popular/full?page=$page"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Serie.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Serie>> fetchTopRatedSeries({int page = 1}) async {
    final response = await http.get(Uri.parse("$_baseUrl/top-rated?page=$page"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Serie.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<Serie?> fetchSerieById(String serieId, {int page = 1}) async {
    final response = await http.get(Uri.parse("$_baseUrl/id/$serieId?page=$page"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Serie.fromJson(data);
    } else {
      return null;
    }
  }

  Future<List<Serie>> searchSerieByTitle(String title, {int page = 1}) async {
    final response = await http.get(Uri.parse("$_baseUrl/title/$title?page=$page"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Serie.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Serie>> fetchSeriesByGenre(String genre, {int page = 1}) async {
  final url = Uri.parse("$_baseUrl/genre/$genre?page=$page");
  print("Fetching from URL: $url");

  final response = await http.get(url);

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((json) => Serie.fromJson(json)).toList();
  } else {
    return [];
  }
}

  Future<List<Serie>> fetchUserSeries(String appUsername) async {
    final url = "http://localhost:5000/users/profile/$appUsername/tv-series";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Serie.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
