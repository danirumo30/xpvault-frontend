import 'package:flutter/material.dart';
import 'package:xpvault/screens/game_detail.dart';
import 'package:xpvault/screens/movie_detail.dart';
import 'package:xpvault/themes/app_color.dart';

import 'my_netimagecontainer.dart';

class MyBuildContentBox extends StatefulWidget {
  final List<dynamic> items;
  final bool showBodyLabel;
  final Widget? returnPage;

  const MyBuildContentBox({
    super.key,
    required this.items,
    this.showBodyLabel = true, this.returnPage,
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

    final ScrollController scrollController = ScrollController();

    return SizedBox(
      height: 200, // Se incrementa un poco para dar espacio al scrollbar
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true, // Hace visible el scrollbar
        trackVisibility: true, // Opcional: muestra la pista del scrollbar
        thickness: 8,
        radius: const Radius.circular(8),
        child: ListView.separated(
          controller: scrollController,
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
                        GameDetailPage(steamId: item.steamId, returnPage: widget.returnPage,),
                  ),
                );
              };
            } else if (typeStr == 'Movie') {
              onTapHandler = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailPage(movieId: item.tmbdId, returnPage: widget.returnPage,),
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
