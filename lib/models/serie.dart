abstract class ContentItem {
  String get itemType;
}

class Serie implements ContentItem {
  @override
  String get itemType => 'Serie';

  final String title;
  final String description;
  final String posterUrl;
  final String headerUrl;
  final int tmbdId;
  final List<String> genres;
  final String releaseDate;
  final double rating;
  final int totalSeasons;
  final int totalEpisodes;
  final int totalTime;
  final List<Season> seasons;
  final List<Person> directors;
  final List<CastMember> casting;

  Serie({
    required this.title,
    required this.description,
    required this.tmbdId,
    required this.genres,
    required this.posterUrl,
    required this.headerUrl,
    required this.releaseDate,
    required this.rating,
    required this.totalSeasons,
    required this.totalEpisodes,
    required this.totalTime,
    required this.seasons,
    required this.directors,
    required this.casting,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      tmbdId: json['tmbdId'] ?? -1,
      posterUrl: json['posterUrl'] as String? ?? '',
      headerUrl: json['headerUrl'] as String? ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      releaseDate: json['releaseDate'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalSeasons: json['totalSeasons'] as int? ?? 0,
      totalEpisodes: json['totalEpisodes'] as int? ?? 0,
      totalTime: json['totalTime'] as int? ?? 0,
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((e) => Season.fromJson(e))
          .toList() ??
          [],
      directors: (json['director'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e))
          .toList() ??
          [],
      casting: (json['casting'] as List<dynamic>?)
          ?.map((e) => CastMember.fromJson(e))
          .toList() ??
          [],
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
        'seasons: ${seasons.map((s) => s.toString()).join(', ')}, '
        'directors: ${directors.map((d) => d.toString()).join(', ')}, '
        'casting: ${casting.map((c) => c.toString()).join(', ')}'
        ')';
  }
}

class Season {
  final int showId;
  final int tmdbId;
  final String name;

  Season({
    required this.showId,
    required this.tmdbId,
    required this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      showId: json['showId'] ?? -1,
      tmdbId: json['tmdbId'] ?? -1,
      name: json['name'] ?? 'Unknown season',
    );
  }

  @override
  String toString() {
    return 'Season(showId: $showId, tmdbId: $tmdbId, name: $name)';
  }
}

class Person implements ContentItem{
  @override
  String get itemType => 'Person';

  final String id;
  final String name;
  final String photoUrl;

  Person({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sin nombre',
      photoUrl: json['photoUrl'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Person(id: $id, name: $name)';
  }
}

class CastMember implements ContentItem{
  @override
  String get itemType => 'CastMember';

  final String id;
  final String name;
  final String character;
  final String photoUrl;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.photoUrl,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sin nombre',
      character: json['character'] ?? 'Sin personaje',
      photoUrl: json['photoUrl'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'CastMember(id: $id, name: $name, character: $character)';
  }
}
