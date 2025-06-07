import 'package:flutter/material.dart';
import 'package:xpvault/controllers/season_controller.dart';
import 'package:xpvault/models/season_detail.dart';
import 'package:xpvault/themes/app_color.dart';

class SeasonDetailDesktopPage extends StatefulWidget {
  final int serieId;
  final int seasonId;
  final Widget? returnPage;

  const SeasonDetailDesktopPage({
    super.key,
    required this.serieId,
    required this.seasonId,
    this.returnPage,
  });

  @override
  State<SeasonDetailDesktopPage> createState() => _SeasonDetailDesktopPageState();
}

class _SeasonDetailDesktopPageState extends State<SeasonDetailDesktopPage> {
  final SeasonController _seasonController = SeasonController();

  SeasonDetail? _seasonDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeasonDetail();
  }

  Future<void> _loadSeasonDetail() async {
    final season = await _seasonController.fetchSeasonById(widget.serieId.toString(), widget.seasonId);
    setState(() {
      _seasonDetail = season;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_seasonDetail == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Season not found",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ),
      );
    }

    final season = _seasonDetail!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Season ${season.seasonNumber}: ${season.title}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (widget.returnPage != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => widget.returnPage!),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              (season.description?.isNotEmpty ?? false)
                  ? season.description!
                  : 'No description available',
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),

            Text(
              'Episodes (${season.episodesCount}):',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: season.episodes.length,
              itemBuilder: (context, index) {
                final episode = season.episodes[index];
                final durationMinutes = episode.totalTime.toString();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: AppColors.surface,
                  child: ListTile(
                    title: Text(
                      'Episode ${episode.episodeNumber}: ${episode.title}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                            (episode.description?.isNotEmpty ?? false)
                                ? episode.description!
                                : 'No description available',
                            style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Time: $durationMinutes min', style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Total time of the season: ${season.totalTime} min',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
