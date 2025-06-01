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
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
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
                        const SizedBox(height: 16),
                        if (serie.firstAirDate != null)
                          Text(
                            "First aired: ${serie.firstAirDate}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                        if (serie.voteAverage != null)
                          Text(
                            "Rating: ${serie.voteAverage!.toStringAsFixed(1)} / 10",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                        if (serie.runtime != null)
                          Text(
                            "Episode duration: ${serie.runtime} minutes",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                        if (serie.creators != null && serie.creators!.isNotEmpty)
                          Text(
                            "Created by: ${serie.creators!.join(', ')}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          serie.description,
                          style: const TextStyle(fontSize: 16, color: AppColors.textMuted),
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
