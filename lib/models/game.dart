class Game {
  final String title;
  final String description;
  final String? screenshotUrl;
  final int steamId;
  final List<String> genres;

  Game({
    required this.title,
    required this.description,
    required this.steamId,
    required this.genres,
    this.screenshotUrl,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      steamId: json['steamId'] ?? -1,
      screenshotUrl: json['screenshotUrl'] as String?,
      genres:  List<String>.from(json['genres'] ?? []),
    );
  }
}
