class Movie {
  final int tmbdId;
  final String title;
  final String description;
  final String releaseDate;
  final double rating;
  final int totalTime;
  final String? posterUrl;
  final String? headerUrl;
  final Director? director;
  final List<Casting> casting;
  final List<String> genres;

  Movie({
    required this.tmbdId,
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.rating,
    required this.totalTime,
    this.posterUrl,
    this.headerUrl,
    this.director,
    required this.casting,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      tmbdId: json['tmbdId'] ?? -1,
      posterUrl: json['posterUrl'] as String?,
      headerUrl: json['headerUrl'] as String?,
      genres: List<String>.from(json['genres'] ?? []),
      releaseDate: json['releaseDate'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalTime: json['totalTime'] ?? 0,
      director: json['director'] != null
          ? Director.fromJson(json['director'])
          : null,
      casting: (json['casting'] as List<dynamic>?)
          ?.map((item) => Casting.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class Director {
  final String id;
  final String name;
  final String? photoUrl;

  Director({
    required this.id,
    required this.name,
    this.photoUrl,
  });

  factory Director.fromJson(Map<String, dynamic> json) {
    return Director(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] as String?,
    );
  }
}

class Casting {
  final String id;
  final String name;
  final String character;
  final String? photoUrl;

  Casting({
    required this.id,
    required this.name,
    required this.character,
    this.photoUrl,
  });

  factory Casting.fromJson(Map<String, dynamic> json) {
    return Casting(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      photoUrl: json['photoUrl'] as String?,
    );
  }
}
