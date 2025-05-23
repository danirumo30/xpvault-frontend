class Game {
  final String title;
  final String description;
  final String? screenshotUrl;

  Game({
    required this.title,
    required this.description,
    this.screenshotUrl,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      screenshotUrl: json['screenshotUrl'] as String?,
    );
  }
}
