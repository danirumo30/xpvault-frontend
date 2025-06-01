import 'steam_user.dart'; // Asegúrate de importar donde esté definido SteamUser

class TopUser {
  final int id;
  final String nickname;
  final String? photoUrl;
  final int totalTime;
  final SteamUser? steamUser;

  TopUser({
    required this.id,
    required this.nickname,
    this.photoUrl,
    required this.totalTime,
    this.steamUser,
  });

  TopUser copyWith({
    String? photoUrl,
    int? totalTime,
    SteamUser? steamUser,
  }) {
    return TopUser(
      id: id,
      nickname: nickname,
      photoUrl: photoUrl ?? this.photoUrl,
      totalTime: totalTime ?? this.totalTime,
      steamUser: steamUser ?? this.steamUser,
    );
  }

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      photoUrl: json['photoUrl'] as String?,
      totalTime: json['totalTime'] as int? ?? 0,
      steamUser: json['steamUser'] != null
          ? SteamUser.fromJson(json['steamUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'photoUrl': photoUrl,
        'totalTime': totalTime,
        'steamUser': steamUser?.toJson(),
      };
}
