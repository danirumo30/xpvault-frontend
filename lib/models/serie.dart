class Serie {
  final String title;
  final String description;
  final String? posterUrl;
  final int tmdbId;
  final List<String> genres;

  Serie({
    required this.title,
    required this.description,
    required this.tmdbId,
    required this.genres,
    this.posterUrl,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      tmdbId: json['tmdbId'] ?? -1,
      posterUrl: json['posterUrl'] as String?,
      genres:  List<String>.from(json['genres'] ?? []),
    );
  }
}
