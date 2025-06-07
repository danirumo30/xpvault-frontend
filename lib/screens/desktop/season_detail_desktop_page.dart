import 'package:flutter/material.dart';
import 'package:xpvault/models/season_detail.dart';
import 'package:xpvault/themes/app_color.dart';

class SeasonDetailDesktopPage extends StatelessWidget {
  final SeasonDetail seasonDetail;
  final Widget? returnPage;

  const SeasonDetailDesktopPage({
    super.key,
    required this.seasonDetail,
    this.returnPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Temporada ${seasonDetail.seasonNumber}: ${seasonDetail.title}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (returnPage != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => returnPage!),
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
              'Descripción:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              (seasonDetail.description?.isNotEmpty ?? false)
                  ? seasonDetail.description!
                  : 'No description available',
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),

            Text(
              'Episodios (${seasonDetail.episodesCount}):',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: seasonDetail.episodes.length,
              itemBuilder: (context, index) {
                final episode = seasonDetail.episodes[index];
                final durationMinutes = episode.totalTime.toString();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: AppColors.surface,
                  child: ListTile(
                    title: Text(
                      'Episodio ${episode.episodeNumber}: ${episode.title}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          (seasonDetail.description?.isNotEmpty ?? false)
                              ? seasonDetail.description!
                              : 'No description available',
                          style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Duración: $durationMinutes min', style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Duración total de la temporada: ${seasonDetail.totalTime} min',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
