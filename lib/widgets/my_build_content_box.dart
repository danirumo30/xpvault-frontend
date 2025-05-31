import 'package:flutter/material.dart';
import 'package:xpvault/screens/desktop/movie_detail_desktop.dart';
import 'package:xpvault/themes/app_color.dart';

import '../screens/desktop/game_detail_desktop.dart';
import 'my_netimagecontainer.dart';

class MyBuildContentBox extends StatefulWidget {
  final List<dynamic> items;
  final bool showBodyLabel;

  const MyBuildContentBox({
    super.key,
    required this.items,
    this.showBodyLabel = true,
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
                        GameDetailDesktopPage(steamId: item.steamId),
                  ),
                );
              };
            } else if (typeStr == 'Movie') {
              onTapHandler = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailDesktopPage(movieId: item.tmbdId),
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
                body: widget.showBodyLabel ? bodyText : '',
                image: imageUrl ?? '',
                onTap: onTapHandler,
              ),
            );
          },
        ),
      ),
    );
  }
}
