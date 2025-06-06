class Episode {
  final int tmbdid;
  final String title;
  final String description;
  final int totalTime;
  final int seasonNumber;
  final int episodeNumber;

  Episode({
    required this.tmbdid,
    required this.title,
    required this.description,
    required this.totalTime,
    required this.seasonNumber,
    required this.episodeNumber,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      tmbdid: json['tmbdid'],
      title: json['title'],
      description: json['description'],
      totalTime: json['totalTime'],
      seasonNumber: json['seasonNumber'],
      episodeNumber: json['episodeNumber'],
    );
  }
}

class SeasonDetail {
  final int tmbdId;
  final int tvShowId;
  final String title;
  final String description;
  final int seasonNumber;
  final int episodesCount;
  final int totalTime;
  final List<Episode> episodes;

  SeasonDetail({
    required this.tmbdId,
    required this.tvShowId,
    required this.title,
    required this.description,
    required this.seasonNumber,
    required this.episodesCount,
    required this.totalTime,
    required this.episodes,
  });

  factory SeasonDetail.fromJson(Map<String, dynamic> json) {
    var episodesJson = json['episodes'] as List;
    List<Episode> episodesList =
        episodesJson.map((e) => Episode.fromJson(e)).toList();

    return SeasonDetail(
      tmbdId: json['tmbdId'],
      tvShowId: json['tvShowId'],
      title: json['title'],
      description: json['description'],
      seasonNumber: json['seasonNumber'],
      episodesCount: json['episodesCount'],
      totalTime: json['totalTime'],
      episodes: episodesList,
    );
  }
}
