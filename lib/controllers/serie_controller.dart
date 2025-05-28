import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/serie.dart';

class SerieController {
  Future<List<Serie>> fetchPopularSeries() async {
    final response = await http.get(Uri.parse("http://localhost:5000/tv-series/popular?page=0"));

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
