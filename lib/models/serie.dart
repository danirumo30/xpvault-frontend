class Serie {
  final String title;
  final String description;
  final String? posterUrl;
  final String? headerUrl;
  final int tmbdId;
  final List<String> genres;
  final String? firstAirDate;
  final double? voteAverage;
  final List<String>? creators;
  final int? runtime;

  Serie({
    required this.title,
    required this.description,
    required this.tmbdId,
    required this.genres,
    this.posterUrl,
    this.headerUrl,
    this.firstAirDate,
    this.voteAverage,
    this.creators,
    this.runtime,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      tmbdId: json['tmbdId'] ?? -1,
      posterUrl: json['posterUrl'] as String?,
      headerUrl: json['headerUrl'] as String?,
      genres: List<String>.from(json['genres'] ?? []),
      firstAirDate: json['firstAirDate'] as String?,
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
      creators: (json['creators'] as List?)?.map((e) => e.toString()).toList(),
      runtime: json['runtime'] as int?,
    );
  }
}
