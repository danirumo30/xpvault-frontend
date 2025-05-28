class Movie {
  final int tmbdId;
  final String title;
  final String description;
  final String releaseDate;
  final double rating;
  final int totalTime;
  final String? posterUrl;
  final Director director;
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
    required this.director,
    required this.casting,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      tmbdId: json['tmbdId'] ?? 0,
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? 'No description',
      releaseDate: json['releaseDate'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalTime: json['totalTime'] ?? 0,
      posterUrl: json['posterUrl'] as String?,
      director: Director.fromJson(json['director']),
      casting: (json['casting'] as List<dynamic>?)
              ?.map((item) => Casting.fromJson(item))
              .toList() ??
          [],
      genres: List<String>.from(json['genres'] ?? []),
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
