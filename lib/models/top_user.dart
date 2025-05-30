class TopUser {
  final int id;
  final String nickname;
  final String? photoUrl;
  final int totalTime;

  TopUser({
    required this.id,
    required this.nickname,
    this.photoUrl,
    required this.totalTime
  });

  TopUser copyWith({
    String? photoUrl,
    int? totalTime
  }) {
    return TopUser(
        id: id,
        nickname: nickname,
        photoUrl: photoUrl ?? this.photoUrl,
        totalTime: totalTime ?? this.totalTime,
    );
  }

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      photoUrl: json['photoUrl'] as String?,
      totalTime: json['totalTime'] as int? ?? 0
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nickname': nickname,
    'photoUrl': photoUrl,
    'totalTime': totalTime
  };
}
