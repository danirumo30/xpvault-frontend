import 'package:xpvault/models/steam_user.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String? profilePhoto;
  final SteamUser? steamUser;
  final int totalTimeMoviesWatched;
  final int totalTimeEpisodesWatched;
  final int totalTimePlayed;
  final int totalFriends;
  final int totalGames;
  final int totalMovies;
  final int totalEpisodes;
  final String? password;
  final String? verificationCode;
  final DateTime? verificationExpiration;
  final DateTime? lastPasswordChange; // Nuevo campo

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePhoto,
    this.steamUser,
    required this.totalTimeMoviesWatched,
    required this.totalTimeEpisodesWatched,
    required this.totalTimePlayed,
    required this.totalFriends,
    required this.totalGames,
    required this.totalMovies,
    required this.totalEpisodes,
    this.password,
    this.verificationCode,
    this.verificationExpiration,
    this.lastPasswordChange, // Nuevo en constructor
  });

  /// Método actualizado para incluir lastPasswordChange
  User copyWith({
    String? username,
    String? email,
    String? profilePhoto,
    SteamUser? steamUser,
    bool setSteamUserToNull = false,
    int? totalTimeMoviesWatched,
    int? totalTimeEpisodesWatched,
    int? totalTimePlayed,
    int? totalFriends,
    int? totalGames,
    int? totalMovies,
    int? totalEpisodes,
    String? password,
    String? verificationCode,
    DateTime? verificationExpiration,
    DateTime? lastPasswordChange, // Nuevo en copyWith
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      steamUser: setSteamUserToNull ? null : (steamUser ?? this.steamUser),
      totalTimeMoviesWatched: totalTimeMoviesWatched ?? this.totalTimeMoviesWatched,
      totalTimeEpisodesWatched: totalTimeEpisodesWatched ?? this.totalTimeEpisodesWatched,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
      totalFriends: totalFriends ?? this.totalFriends,
      totalGames: totalGames ?? this.totalGames,
      totalMovies: totalMovies ?? this.totalMovies,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      password: password ?? this.password,
      verificationCode: verificationCode ?? this.verificationCode,
      verificationExpiration: verificationExpiration ?? this.verificationExpiration,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange, // Nuevo
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
      totalTimePlayed: json['totalTimePlayed'] ?? 0,
      totalFriends: json['totalFriends'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
      totalMovies: json['totalMovies'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
      password: json['password'],
      verificationCode: json['verificationCode'],
      verificationExpiration: json['verificationExpiration'] != null
          ? DateTime.tryParse(json['verificationExpiration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'profilePhoto': profilePhoto,
      'steamUser': steamUser?.toJson(),
      'totalTimePlayed': totalTimePlayed,
      'totalTimeMoviesWatched': totalTimeMoviesWatched,
      'totalTimeEpisodesWatched': totalTimeEpisodesWatched,
      'totalFriends': totalFriends,
      'totalGames': totalGames,
      'totalMovies': totalMovies,
      'totalEpisodes': totalEpisodes,
      'verificationCode': verificationCode,
      'verificationExpiration': verificationExpiration?.toIso8601String(),
    };

    if (password != null) {
      data['password'] = password;
    }

    return data;
  }
}
