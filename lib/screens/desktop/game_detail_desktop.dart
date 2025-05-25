import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/news.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/build_bullet.dart';
import 'package:xpvault/widgets/my_imagecontainer.dart';

class GameDetailDesktopPage extends StatefulWidget {
  final Game game;

  const GameDetailDesktopPage({super.key, required this.game});

  @override
  State<GameDetailDesktopPage> createState() => _GameDetailDesktopPageState();
}

class _GameDetailDesktopPageState extends State<GameDetailDesktopPage> {
  final GameController _gameController = GameController();

  bool _searchingNews = true;
  List<News> gameNews = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    late List<News> news;

    if (_searchingNews) {
      news = await _gameController.getGameNewsById(widget.game.steamId);
    }

    setState(() {
      gameNews = news;
      _searchingNews = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const String defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";
    final imageUrl =
        (widget.game.screenshotUrl?.trim().isNotEmpty ?? false)
            ? widget.game.screenshotUrl!
            : defaultImage;

    print(gameNews.toList());

    return DesktopLayout(
  title: "XPVAULT",
  body: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: screenHeight * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.game.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.game.description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Genres",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: widget.game.genres
                          .map((genre) => BuildBullet(text: genre))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "News",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Column(
                      children: gameNews
                          .map(
                            (gameNews) => MyImageContainer(
                              title: gameNews.title,
                              body: gameNews.contents,
                              image: "assets/solid_color.jpg",
                              onTap: () async {
                                final rawUrl = gameNews.url.trim();
                                final uri = Uri.tryParse(rawUrl);

                                if (uri == null) {
                                  print("Invalid URL: $rawUrl");
                                  return;
                                }

                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SteamPage()),
              );
            },
            child: const Text("Go back"),
          ),
        ),
      ],
    ),
  ),
);

  }
}
