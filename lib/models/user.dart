class User {
  final int id;
  final String username;
  final String email;
  final String? steamId;
  final String? profilePhoto;
  final int totalTimePlayed;
  final int totalTimeMoviesWatched;
  final int totalTimeEpisodesWatched;
  final int totalFriends;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.steamId,
    this.profilePhoto,
    required this.totalTimePlayed,
    required this.totalTimeMoviesWatched,
    required this.totalTimeEpisodesWatched,
    required this.totalFriends
  });

  User copyWith({
    String? steamId,
    String? profilePhoto,
    int? totalTimePlayed,
    int? totalTimeMoviesWatched,
    int? totalTimeEpisodesWatched,
    int? totalFriends
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      steamId: steamId ?? this.steamId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
      totalTimeMoviesWatched: totalTimeMoviesWatched ?? this.totalTimeMoviesWatched,
      totalTimeEpisodesWatched: totalTimeEpisodesWatched ?? this.totalTimeEpisodesWatched,
      totalFriends: totalFriends ?? this.totalFriends
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      steamId: json['steamId']?.toString() ?? json['steamUser']?['steamId']?.toString(),
      profilePhoto: json['profilePhoto'],
      totalTimePlayed: json['totalTimePlayed'] ?? 0,
      totalTimeMoviesWatched: json['totalTimeMoviesWatched'] ?? 0,
      totalTimeEpisodesWatched: json['totalTimeEpisodesWatched'] ?? 0,
      totalFriends: json['totalFriends'] ?? 0
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'steamId': steamId,
    'profilePhoto': profilePhoto,
    'totalTimePlayed': totalTimePlayed,
    'totalTimeMoviesWatched': totalTimeMoviesWatched,
    'totalTimeEpisodesWatched': totalTimeEpisodesWatched,
    'totalFriends': totalFriends
  };
}
