import 'package:flutter/material.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/themes/app_color.dart';

import '../screens/desktop/game_detail_desktop.dart';

class MyBuildContentBox extends StatefulWidget {
  final List<dynamic> items;

  const MyBuildContentBox({
    super.key,
    required this.items,
  });

  @override
  State<MyBuildContentBox> createState() => _MyBuildContentBoxState();
}

class _MyBuildContentBoxState extends State<MyBuildContentBox> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Contenido próximamente...",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final String title;
            String? imageUrl;

            if (item is Game) {
              title = item.title;
              imageUrl = item.screenshotUrl;
            } else if (item is Movie) {
              title = item.title;
              imageUrl = item.posterUrl;
            } else if (item is Serie) {
              title = item.title;
              imageUrl = item.posterUrl;
            } else {
              title = 'Unknown';
              imageUrl = null;
            }

            Widget content = Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 50),
                            )
                          : const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    width: double.infinity,
                    color: Colors.white,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );

            if (item.runtimeType.toString() == 'Game') {
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailDesktopPage(game: item),
                    ),
                  );
                },
                child: content,
              );
            } else {
              return content;
            }
          },
        ),
      ),
    );
  }
}

