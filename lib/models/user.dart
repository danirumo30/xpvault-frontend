import 'package:xpvault/models/steamUser.dart';

class User {
  final int id;
  final String username;
  final String email;
  SteamUser? steamUser;
  final String? profilePhoto;
  final int totalTimePlayed;
  final int totalTimeMoviesWatched;
  final int totalTimeEpisodesWatched;
  final int totalGames;
  final int totalMovies;
  final int totalEpisodes;
  final int totalFriends;
  String? password;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.steamUser,
    this.profilePhoto,
    required this.totalTimePlayed,
    required this.totalTimeMoviesWatched,
    required this.totalTimeEpisodesWatched,
    required this.totalGames,
    required this.totalMovies,
    required this.totalEpisodes,
    required this.totalFriends,
    this.password,
  });

  User copyWith({
    SteamUser? steamUser,
    String? profilePhoto,
    int? totalTimePlayed,
    int? totalTimeMoviesWatched,
    int? totalTimeEpisodesWatched,
    int? totalGames,
    int? totalMovies,
    int? totalEpisodes,
    int? totalFriends,
    String? password,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      steamUser: steamUser ?? this.steamUser,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
      totalTimeMoviesWatched: totalTimeMoviesWatched ?? this.totalTimeMoviesWatched,
      totalTimeEpisodesWatched: totalTimeEpisodesWatched ?? this.totalTimeEpisodesWatched,
      totalGames: totalGames ?? this.totalGames,
      totalMovies: totalMovies ?? this.totalMovies,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      totalFriends: totalFriends ?? this.totalFriends,
      password: password ?? this.password,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      steamUser: json['steamUser'] != null
          ? SteamUser.fromJson(json['steamUser'])
          : null,
      profilePhoto: json['profilePhoto'],
      totalTimePlayed: json['totalTimePlayed'] ?? 0,
      totalTimeMoviesWatched: json['totalTimeMoviesWatched'] ?? 0,
      totalTimeEpisodesWatched: json['totalTimeEpisodesWatched'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
      totalMovies: json['totalMovies'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
      totalFriends: json['totalFriends'] ?? 0,
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'username': username,
      'email': email,
      'profilePhoto': profilePhoto,
      'steamUser': steamUser?.toJson(),
      'totalTimeMoviesWatched': totalTimeMoviesWatched,
      'totalTimeEpisodesWatched': totalTimeEpisodesWatched,
      'totalGames': totalGames,
      'totalMovies': totalMovies,
      'totalEpisodes': totalEpisodes,
      'totalFriends': totalFriends,
    };

    if (password != null) {
      data['password'] = password;
    }

    return data;
  }
}
