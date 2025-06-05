import 'package:flutter/material.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/themes/app_color.dart';

class SerieDetailDesktopPage extends StatelessWidget {
  final Serie serie;
  final Widget? returnPage;

  const SerieDetailDesktopPage({
    super.key,
    required this.serie,
    this.returnPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(serie.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 16),
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
                    ...serie.seasons!
                        .map(
                          (s) => Text(
                            '• ${s.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                        )
                        .toList(),
                  const SizedBox(height: 16),
                  if (serie.totalTime != null)
                    Text(
                      'Total viewing time: ${serie.totalTime} min',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (serie.directors != null && serie.directors!.isNotEmpty)
                    Column(
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
                                      child: Image.network(
                                        d.photoUrl ?? '',
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.person, size: 64),
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
                  const SizedBox(height: 24),
                  if (serie.casting != null && serie.casting!.isNotEmpty)
                    Column(
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
                                      child: Image.network(
                                        a.photoUrl ?? '',
                                        width: 64,
                                        height: 96,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.person, size: 64),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
