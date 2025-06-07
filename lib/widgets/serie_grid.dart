import 'package:flutter/material.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/themes/app_color.dart';

class SerieGrid extends StatelessWidget {
  final List<Serie> series;
  final bool isLoading;
  final void Function(Serie) onSerieTap;

  const SerieGrid({
    super.key,
    required this.series,
    required this.isLoading,
    required this.onSerieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (series.isEmpty) {
      return const Center(child: Text("No series found"));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.58, // Más espacio vertical para texto
      ),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final serie = series[index];
        return GestureDetector(
          onTap: () => onSerieTap(serie),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: serie.posterUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            serie.posterUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: const Icon(Icons.tv, size: 50),
                        ),
                ),
                Expanded( // Asegura que el texto se ajuste en el espacio restante
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      serie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.2,
                        overflow: TextOverflow.ellipsis,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 2.0,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
