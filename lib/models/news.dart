class News {
  final String title;
  final String url;
  final String author;
  final String contents;

  News({required this.title, required this.url, required this.author, required this.contents});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(title: json['title'], url: json['url'], author: json['author'], contents: json['contents']);
  }
}