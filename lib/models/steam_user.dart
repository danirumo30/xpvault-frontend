class SteamUser {
  final String? steamId;
  final String? nickname;
  final String? avatar;
  final String? profileUrl;
  final int totalTimePlayed;
  final List<String>? ownedGames;

  SteamUser({
    this.steamId,
    this.nickname,
    this.avatar,
    this.profileUrl,
    this.totalTimePlayed = 0,
    this.ownedGames,
  });

  SteamUser copyWith({
    String? steamId,
    String? nickname,
    String? avatar,
    String? profileUrl,
    int? totalTimePlayed,
    List<String>? ownedGames,
  }) {
    return SteamUser(
      steamId: steamId ?? this.steamId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      profileUrl: profileUrl ?? this.profileUrl,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
      ownedGames: ownedGames ?? this.ownedGames,
    );
  }

  factory SteamUser.fromJson(Map<String, dynamic> json) {
    return SteamUser(
      steamId: json['steamId']?.toString(),
      nickname: json['nickname'],
      avatar: json['avatar'],
      profileUrl: json['profileUrl'],
      totalTimePlayed: json['totalTimePlayed'] ?? 0,
      ownedGames: json['ownedGames'] != null
          ? List<String>.from(json['ownedGames'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steamId': steamId,
      'nickname': nickname ?? '',
      'avatar': avatar ?? '',
      'profileUrl': profileUrl ?? '',
      'totalTimePlayed': totalTimePlayed,
      'ownedGames': ownedGames,
    };
  }
}
