class BasicUser {
  final int id;
  final String username;
  final String? profilePhoto;
  final int totalTimeMoviesWatched;
  final int totalTimeEpisodesWatched;
  final int totalTimePlayed;

  BasicUser({
    required this.id,
    required this.username,
    this.profilePhoto,
    required this.totalTimeMoviesWatched,
    required this.totalTimeEpisodesWatched,
    required this.totalTimePlayed,
  });

  BasicUser copyWith({
    String? profilePhoto,
    int? totalTimeMoviesWatched,
    int? totalTimeEpisodesWatched,
    int? totalTimePlayed,
  }) {
    return BasicUser(
      id: id,
      username: username,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      totalTimeMoviesWatched:
        totalTimeMoviesWatched ?? this.totalTimeMoviesWatched,
      totalTimeEpisodesWatched:
        totalTimeEpisodesWatched ?? this.totalTimeEpisodesWatched,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
    );
  }

  factory BasicUser.fromJson(Map<String, dynamic> json) {
    return BasicUser(
      id: json['id'] as int,
      username: json['username'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      totalTimeMoviesWatched: json['totalTimeMoviesWatched'] ?? 0,
      totalTimeEpisodesWatched: json['totalTimeEpisodesWatched'] ?? 0,
      totalTimePlayed: json['totalTimePlayed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'profilePhoto': profilePhoto,
        'totalTimeMoviesWatched': totalTimeMoviesWatched,
        'totalTimeEpisodesWatched': totalTimeEpisodesWatched,
        'totalTimePlayed': totalTimePlayed,
      };
}
