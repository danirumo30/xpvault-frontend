class Episode {
  final int tmbdid;
  final String title;
  final String? description;
  final int? totalTime;
  final int seasonNumber;
  final int episodeNumber;

  Episode({
    required this.tmbdid,
    required this.title,
    this.description,
    this.totalTime,
    required this.seasonNumber,
    required this.episodeNumber,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      tmbdid: (json['tmbdid'] is int) ? json['tmbdid'] as int : -1,
      title: json['title'] as String? ?? 'Sin título',
      description: json['description'] as String?,
      totalTime: (json['totalTime'] is int) ? json['totalTime'] as int : null,
      seasonNumber: (json['seasonNumber'] is int) ? json['seasonNumber'] as int : -1,
      episodeNumber: (json['episodeNumber'] is int) ? json['episodeNumber'] as int : -1,
    );
  }
}

class SeasonDetail {
  final int tmbdId;
  final int tvShowId;
  final String title;
  final String? description;
  final int seasonNumber;
  final int episodesCount;
  final int totalTime;
  final List<Episode> episodes;

  SeasonDetail({
    required this.tmbdId,
    required this.tvShowId,
    required this.title,
    this.description,
    required this.seasonNumber,
    required this.episodesCount,
    required this.totalTime,
    required this.episodes,
  });

  factory SeasonDetail.fromJson(Map<String, dynamic> json) {
    var episodesJson = json['episodes'] as List<dynamic>? ?? [];
    List<Episode> episodesList = episodesJson.map((e) => Episode.fromJson(e)).toList();

    return SeasonDetail(
      tmbdId: (json['tmbdId'] is int) ? json['tmbdId'] as int : -1,
      tvShowId: (json['tvShowId'] is int) ? json['tvShowId'] as int : -1,
      title: json['title'] as String? ?? 'Sin título',
      description: json['description'] as String?,
      seasonNumber: (json['seasonNumber'] is int) ? json['seasonNumber'] as int : -1,
      episodesCount: (json['episodesCount'] is int) ? json['episodesCount'] as int : 0,
      totalTime: (json['totalTime'] is int) ? json['totalTime'] as int : 0,
      episodes: episodesList,
    );
  }
}
