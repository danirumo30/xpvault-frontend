import 'achievement.dart';

class Game {
  final String title;
  final String description;
  final String? screenshotUrl;
  final String? headerUrl;
  final int steamId;
  final List<String> genres;
  final int price;
  final int totalAchievements;
  final List<Achievement> achievements;

  Game({
    required this.title,
    required this.description,
    required this.steamId,
    required this.genres,
    this.screenshotUrl,
    this.headerUrl,
    this.price = 0,
    this.totalAchievements = 0,
    this.achievements = const [],
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      steamId: json['steamId'] ?? -1,
      screenshotUrl: json['screenshotUrl'] as String?,
      headerUrl: json['headerUrl'] as String?,
      genres: List<String>.from(json['genres'] ?? []),
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      totalAchievements: json['totalAchievements'] ?? 0,
      achievements: json['achievements'] != null && json['achievements'] is List
          ? (json['achievements'] as List)
          .map((a) => Achievement.fromJson(a))
          .toList()
          : [],
    );
  }

  @override
  String toString() {
    return 'Game(title: $title, description: $description, price: $price, steamId: $steamId, screenshotUrl: $screenshotUrl, headerUrl: $headerUrl, genres: $genres, achievements: $achievements)';
  }
}
