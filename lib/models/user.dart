class User {
  final int id;
  final String username;
  final String email;
  final int? steamId;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.steamId,
  });

  User copyWith({int? steamId}) {
    return User(
      id: id,
      username: username,
      email: email,
      steamId: steamId ?? this.steamId,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        steamId: json['steamId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'steamId': steamId,
      };
}
