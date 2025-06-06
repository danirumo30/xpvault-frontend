import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/season_detail.dart';

class SeasonController {
  final String _baseUrl = "http://localhost:5000/tv-series";

  Future<SeasonDetail?> fetchSeasonById(String tvSerieId, int seasonId) async {
    final uri = Uri.parse("$_baseUrl/season/$tvSerieId").replace(queryParameters: {
      'seasonId': seasonId.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SeasonDetail.fromJson(data);
    } else {
      return null;
    }
  }
}
