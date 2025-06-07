class Serie {
  final String title;
  final String description;
  final String? posterUrl;
  final String? headerUrl;
  final int tmbdId;
  final List<String> genres;
  final String? releaseDate;
  final double? rating;
  final int? totalSeasons;
  final int? totalEpisodes;
  final int? totalTime;
  final List<Season>? seasons;
  final List<Person>? directors;
  final List<CastMember>? casting;

  Serie({
    required this.title,
    required this.description,
    required this.tmbdId,
    required this.genres,
    this.posterUrl,
    this.headerUrl,
    this.releaseDate,
    this.rating,
    this.totalSeasons,
    this.totalEpisodes,
    this.totalTime,
    this.seasons,
    this.directors,
    this.casting,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      tmbdId: json['tmbdId'] ?? -1,
      posterUrl: json['posterUrl'] as String?,
      headerUrl: json['headerUrl'] as String?,
      genres: List<String>.from(json['genres'] ?? []),
      releaseDate: json['releaseDate'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalSeasons: json['totalSeasons'] as int?,
      totalEpisodes: json['totalEpisodes'] as int?,
      totalTime: json['totalTime'] as int?,
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((e) => Season.fromJson(e))
          .toList(),
      directors: (json['director'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e))
          .toList(),
      casting: (json['casting'] as List<dynamic>?)
          ?.map((e) => CastMember.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Serie('
        'title: $title, '
        'description: $description, '
        'tmbdId: $tmbdId, '
        'posterUrl: $posterUrl, '
        'headerUrl: $headerUrl, '
        'genres: $genres, '
        'releaseDate: $releaseDate, '
        'rating: $rating, '
        'totalSeasons: $totalSeasons, '
        'totalEpisodes: $totalEpisodes, '
        'totalTime: $totalTime, '
        'seasons: ${seasons?.map((s) => s.toString()).join(', ') ?? '[]'}, '
        'directors: ${directors?.map((d) => d.toString()).join(', ') ?? '[]'}, '
        'casting: ${casting?.map((c) => c.toString()).join(', ') ?? '[]'}'
        ')';
  }
}

class Season {
  final int showId;
  final int tmbdId;
  final String name;

  Season({
    required this.showId,
    required this.tmbdId,
    required this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      showId: json['showId'] ?? -1,
      tmbdId: json['tmbdId'] ?? -1,
      name: json['name'] ?? 'Temporada desconocida',
    );
  }
}

class Person {
  final String id;
  final String name;
  final String? photoUrl;

  Person({
    required this.id,
    required this.name,
    this.photoUrl,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sin nombre',
      photoUrl: json['photoUrl'] as String?,
    );
  }
}

class CastMember {
  final String id;
  final String name;
  final String character;
  final String? photoUrl;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.photoUrl,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sin nombre',
      character: json['character'] ?? 'Sin personaje',
      photoUrl: json['photoUrl'] as String?,
    );
  }

  @override
  String toString() {
    return 'CastMember(id: $id, name: $name, character: $character)';
  }
}
