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
        childAspectRatio: 0.58,
      ),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final serie = series[index];
        return _HoverSerieCard(
          serie: serie,
          onTap: () => onSerieTap(serie),
        );
      },
    );
  }
}

class _HoverSerieCard extends StatefulWidget {
  final Serie serie;
  final VoidCallback onTap;

  const _HoverSerieCard({
    required this.serie,
    required this.onTap,
  });

  @override
  State<_HoverSerieCard> createState() => _HoverSerieCardState();
}

class _HoverSerieCardState extends State<_HoverSerieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary,
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: Colors.black.withValues(),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: widget.serie.posterUrl != null
                      ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.network(
                      widget.serie.posterUrl,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.serie.title,
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
        ),
      ),
    );
  }
}
