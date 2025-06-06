import 'package:flutter/material.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/screens/desktop/season_detail_desktop_page.dart';
import 'package:xpvault/controllers/season_controller.dart';

class SerieDetailDesktopPage extends StatelessWidget {
  final Serie serie;
  final Widget? returnPage;

  SerieDetailDesktopPage({
    Key? key,
    required this.serie,
    this.returnPage,
  }) : super(key: key);

  final SeasonController seasonController = SeasonController();

  void _showSeasonDetail(BuildContext context, Season season) async {
    print("Season name: ${season.name}");
    print("Season tmbdId: ${season.tmbdId}");
    print("Show ID: ${season.showId}");
    
    final seasonDetail = await seasonController.fetchSeasonById(
      season.showId.toString(),
      season.tmbdId,
    );

    print("Fetched detail title: ${seasonDetail?.title}");

    if (seasonDetail != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeasonDetailDesktopPage(
            seasonDetail: seasonDetail,
            returnPage: this, // referencia válida al volver a esta pantalla
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load season details")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          serie.title,
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
        child: Column(
          children: [
            if (serie.headerUrl != null)
              Image.network(
                serie.headerUrl!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 250,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (serie.posterUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        serie.posterUrl!,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serie.title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (serie.genres.isNotEmpty)
                          Wrap(
                            spacing: 8.0,
                            children: serie.genres
                                .map((g) => Chip(
                                      label: Text(g),
                                      backgroundColor: AppColors.secondary,
                                      labelStyle: const TextStyle(color: Colors.white),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 12),
                        if (serie.releaseDate != null || serie.rating != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                if (serie.releaseDate != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          color: AppColors.accent, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        serie.releaseDate!,
                                        style: const TextStyle(
                                            color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                if (serie.releaseDate != null && serie.rating != null)
                                  const SizedBox(width: 16),
                                if (serie.rating != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        serie.rating!.toStringAsFixed(1),
                                        style: const TextStyle(
                                            color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        Text(
                          serie.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (serie.totalSeasons != null && serie.totalEpisodes != null)
                    Text(
                      'Seasons (${serie.totalSeasons}) - Episodes: ${serie.totalEpisodes}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (serie.seasons != null && serie.seasons!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: serie.seasons!
                          .map(
                            (s) => InkWell(
                              onTap: () => _showSeasonDetail(context, s),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  '• ${s.name}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textMuted,
                                    decoration: TextDecoration.underline, // para que parezca clicable
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      ),
                    ),
                  if (serie.totalTime != null)
                    Text(
                      'Total viewing time: ${serie.totalTime! ~/ 60}h ${serie.totalTime! % 60}m',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (serie.directors != null && serie.directors!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Directors:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            children: serie.directors!
                                .map(
                                  (d) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipOval(
                                        child: d.photoUrl != null &&
                                                d.photoUrl!.isNotEmpty
                                            ? Image.network(
                                                d.photoUrl!,
                                                width: 64,
                                                height: 64,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const Icon(Icons.person,
                                                        size: 64),
                                              )
                                            : Container(
                                                width: 64,
                                                height: 64,
                                                color: AppColors.secondary,
                                                child: Center(
                                                  child: Text(
                                                    d.name.isNotEmpty
                                                        ? d.name[0]
                                                        : '?',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        d.name,
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  if (serie.casting != null && serie.casting!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Main Cast:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: serie.casting!
                                .map(
                                  (a) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: a.photoUrl != null &&
                                                a.photoUrl!.isNotEmpty
                                            ? Image.network(
                                                a.photoUrl!,
                                                width: 64,
                                                height: 96,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const Icon(Icons.person,
                                                        size: 64),
                                              )
                                            : Container(
                                                width: 64,
                                                height: 96,
                                                color: AppColors.secondary,
                                                child: Center(
                                                  child: Text(
                                                    a.name.isNotEmpty
                                                        ? a.name[0]
                                                        : '?',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        a.name,
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        a.character,
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
