class BasicUser {
  final int id;
  final String nickname;
  final String? photoUrl;
  final int totalTime;

  BasicUser({
    required this.id,
    required this.nickname,
    this.photoUrl,
    required this.totalTime,
  });

  BasicUser copyWith({
    String? photoUrl,
    int? totalTime,
  }) {
    return BasicUser(
      id: id,
      nickname: nickname,
      photoUrl: photoUrl ?? this.photoUrl,
      totalTime: totalTime ?? this.totalTime,
    );
  }

  factory BasicUser.fromJson(Map<String, dynamic> json) {
    return BasicUser(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      photoUrl: json['photoUrl'] as String?,
      totalTime: json['totalTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'photoUrl': photoUrl,
        'totalTime': totalTime,
      };
}
