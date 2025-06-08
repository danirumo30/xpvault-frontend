import 'package:flutter/material.dart';
import 'package:xpvault/controllers/season_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/season_detail.dart';
import 'package:xpvault/themes/app_color.dart';

class SeasonDetailMobilePage extends StatefulWidget {
  final int serieId;
  final int seasonId;
  final Widget? returnPage;

  const SeasonDetailMobilePage({
    super.key,
    required this.serieId,
    required this.seasonId,
    this.returnPage,
  });

  @override
  State<SeasonDetailMobilePage> createState() => _SeasonDetailMobilePageState();
}

class _SeasonDetailMobilePageState extends State<SeasonDetailMobilePage> {
  final SeasonController _seasonController = SeasonController();

  SeasonDetail? _seasonDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeasonDetail();
  }

  Future<void> _loadSeasonDetail() async {
    final season = await _seasonController.fetchSeasonById(
      widget.serieId.toString(),
      widget.seasonId,
    );
    setState(() {
      _seasonDetail = season;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MobileLayout(
        title: "XPVAULT",
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (_seasonDetail == null) {
      return MobileLayout(
        title: "XPVAULT",
        body: const Center(
          child: Text(
            "Season not found",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ),
      );
    }

    final season = _seasonDetail!;

    return MobileLayout(
      title: "XPVAULT",
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Row(
            children: [
              if (widget.returnPage != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.accent),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => widget.returnPage!),
                    );
                  },
                ),
              Text(
                'Season ${season.seasonNumber}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '📘 Description',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              (season.description?.isNotEmpty ?? false)
                  ? season.description!
                  : 'No description available',
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '🎬 Episodes (${season.episodesCount})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...season.episodes.map((episode) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accent.withOpacity(0.15),
                        child: Text(
                          episode.episodeNumber.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          episode.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (episode.description?.isNotEmpty ?? false)
                        ? episode.description!
                        : 'No description available',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 18, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(
                        '${episode.totalTime} min',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: ${season.totalTime} min',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
