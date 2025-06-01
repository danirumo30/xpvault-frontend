import 'package:xpvault/models/steam_user.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String? profilePhoto;
  SteamUser? steamUser;
  final int totalTimeMoviesWatched;
  final int totalTimeEpisodesWatched;
  final int totalGames;
  final int totalMovies;
  final int totalEpisodes;
  String? password;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePhoto,
    this.steamUser,
    required this.totalTimeMoviesWatched,
    required this.totalTimeEpisodesWatched,
    required this.totalGames,
    required this.totalMovies,
    required this.totalEpisodes,
    this.password,
  });

  User copyWith({
    String? username,
    String? email,
    String? profilePhoto,
    SteamUser? steamUser,
    int? totalTimeMoviesWatched,
    int? totalTimeEpisodesWatched,
    int? totalGames,
    int? totalMovies,
    int? totalEpisodes,
    String? password,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      steamUser: steamUser ?? this.steamUser,
      totalTimeMoviesWatched:
          totalTimeMoviesWatched ?? this.totalTimeMoviesWatched,
      totalTimeEpisodesWatched:
          totalTimeEpisodesWatched ?? this.totalTimeEpisodesWatched,
      totalGames: totalGames ?? this.totalGames,
      totalMovies: totalMovies ?? this.totalMovies,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      password: password ?? this.password,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
      steamUser: json['steamUser'] != null
          ? SteamUser.fromJson(json['steamUser'])
          : null,
      totalTimeMoviesWatched: json['totalTimeMoviesWatched'] ?? 0,
      totalTimeEpisodesWatched: json['totalTimeEpisodesWatched'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
      totalMovies: json['totalMovies'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
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
    };

    if (password != null) {
      data['password'] = password;
    }

    return data;
  }
}