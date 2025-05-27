class Movie {
  final String title;
  final String description;
  final String? posterUrl;
  final int tmdbId;
  final List<String> genres;

  Movie({
    required this.title,
    required this.description,
    required this.tmdbId,
    required this.genres,
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      tmdbId: json['tmdbId'] ?? -1,
      posterUrl: json['posterUrl'] as String?,
      genres:  List<String>.from(json['genres'] ?? []),
    );
  }
}
