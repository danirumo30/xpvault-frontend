abstract class ContentItem {
  String get itemType;
}

class Achievement implements ContentItem {
  @override
  String get itemType => 'Achievement';

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

