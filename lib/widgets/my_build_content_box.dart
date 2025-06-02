import 'package:flutter/material.dart';
import 'package:xpvault/screens/game_detail.dart';
import 'package:xpvault/screens/movie_detail.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/themes/app_color.dart';

import 'my_netimagecontainer.dart';

class MyBuildContentBox extends StatelessWidget {
  final List<dynamic> items;
  final bool showBodyLabel;
  final Widget? returnPage;

  const MyBuildContentBox({
    super.key,
    required this.items,
    this.showBodyLabel = true,
    this.returnPage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
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
              offset: const Offset(0, 4),
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

    final ScrollController scrollController = ScrollController();

    final firstTypeStr = items[0].runtimeType.toString();

    void Function()? onShowAllTap;
    if (firstTypeStr == 'Game') {
      onShowAllTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SteamPage(),
          ),
        );
      };
    } else if (firstTypeStr == 'Movie') {
      onShowAllTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviesSeriesPage(),
          ),
        );
      };
    } else if (firstTypeStr == 'Serie') {
      onShowAllTap = null;
    } else {
      onShowAllTap = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: MouseRegion(
              cursor: onShowAllTap != null ? SystemMouseCursors.click : MouseCursor.defer,
              child: GestureDetector(
                onTap: onShowAllTap,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    bool isHovered = false;
                    return MouseRegion(
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      cursor: onShowAllTap != null ? SystemMouseCursors.click : MouseCursor.defer,
                      child: Text(
                        "Show All",
                        style: TextStyle(
                          color: onShowAllTap != null
                              ? (isHovered ? AppColors.accentLight : Colors.white)
                              : AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                          decoration: onShowAllTap != null
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 8,
            radius: const Radius.circular(8),
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final String title;
                String? imageUrl;
                String bodyText;

                final typeStr = item.runtimeType.toString();

                if (typeStr == 'Game') {
                  title = item.title;
                  imageUrl = item.screenshotUrl;
                  bodyText = "Juego";
                } else if (typeStr == 'Movie') {
                  title = item.title;
                  imageUrl = item.posterUrl;
                  bodyText = "Película";
                } else if (typeStr == 'Serie') {
                  title = item.title;
                  imageUrl = item.posterUrl;
                  bodyText = "Serie";
                } else if (typeStr == 'Achievement') {
                  title = item.name ?? 'Desconocido';
                  imageUrl = item.url;
                  bodyText = "Logro";
                } else {
                  title = 'Desconocido';
                  imageUrl = null;
                  bodyText = '';
                }

                void Function()? onTapHandler;
                if (typeStr == 'Game') {
                  onTapHandler = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GameDetailPage(steamId: item.steamId, returnPage: returnPage),
                      ),
                    );
                  };
                } else if (typeStr == 'Movie') {
                  onTapHandler = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(movieId: item.tmbdId, returnPage: returnPage),
                      ),
                    );
                  };
                } else {
                  onTapHandler = null;
                }

                return SizedBox(
                  width: 120,
                  child: MyNetImageContainer(
                    title: title,
                    body: showBodyLabel ? bodyText : '',
                    image: imageUrl ?? '',
                    onTap: onTapHandler,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
