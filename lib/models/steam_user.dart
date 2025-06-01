class SteamUser {
  final String? steamId;
  final String? nickname;
  final String? avatar;
  final String? profileUrl;
  final int totalTimePlayed;

  SteamUser({
    this.steamId,
    this.nickname,
    this.avatar,
    this.profileUrl,
    this.totalTimePlayed = 0,
  });

  SteamUser copyWith({
    String? steamId,
    String? nickname,
    String? avatar,
    String? profileUrl,
    int? totalTimePlayed,
  }) {
    return SteamUser(
      steamId: steamId ?? this.steamId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      profileUrl: profileUrl ?? this.profileUrl,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
    );
  }

  factory SteamUser.fromJson(Map<String, dynamic> json) {
    return SteamUser(
      steamId: json['steamId']?.toString(),
      nickname: json['nickname'],
      avatar: json['avatar'],
      profileUrl: json['profileUrl'],
      totalTimePlayed: json['totalTimePlayed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steamId': steamId,
      'nickname': nickname,
      'avatar': avatar,
      'profileUrl': profileUrl,
      'totalTimePlayed': totalTimePlayed,
    };
  }
}