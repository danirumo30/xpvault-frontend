class Achievement {
  final String name;
  final String url;

  Achievement({
    required this.name,
    required this.url,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

