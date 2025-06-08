import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/news.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/themes/app_color.dart';

class GameDetailMobilePage extends StatefulWidget {
  final int steamId;
  final Widget? returnPage;

  const GameDetailMobilePage({
    super.key,
    required this.steamId,
    this.returnPage,
  });

  @override
  State<GameDetailMobilePage> createState() => _GameDetailMobilePageState();
}

class _GameDetailMobilePageState extends State<GameDetailMobilePage> {
  final GameController _gameController = GameController();
  Game? _game;
  List<News> gameNews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameAndNews();
  }

  Future<void> _loadGameAndNews() async {
    final game = await _gameController.getGameBySteamId(widget.steamId);
    final news = await _gameController.getGameNewsById(widget.steamId);
    setState(() {
      _game = game;
      gameNews = news;
      _isLoading = false;
    });
  }

  String resolveImageUrl(String? url) {
    return (url == null || url.isEmpty)
        ? "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png"
        : url;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_game == null) {
      return MobileLayout(
        title: "XPVAULT",
        body: const Center(child: Text("Game not found")),
      );
    }

    return MobileLayout(
      title: "XPVAULT",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Header
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                resolveImageUrl(_game!.headerUrl),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Game Title
            Text(
              _game!.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              _game!.description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),

            // Price
            Text(
              "Price: ${(_game!.price / 100).toStringAsFixed(2)} €",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Tags
            Text(
              "Tags",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _game!.genres.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blueGrey[700],
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Achievements
            Text(
              "Achievements",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_game!.achievements.isEmpty)
              Text(
                "No achievements available.",
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _game!.achievements.map((achievement) {
                  final imageUrl = _gameController.proxiedSteamImage(
                    achievement.url,
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: Text(
                          achievement.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            // News
            Text(
              "News",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (gameNews.isEmpty)
              Text(
                "No news found.",
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              Column(
                children: gameNews.map((newsItem) {
                  return GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(newsItem.url);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newsItem.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            newsItem.contents,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

            // Back Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  if (widget.returnPage != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => widget.returnPage!,
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SteamPage(),
                      ),
                    );
                  }
                },
                child: const Text("Go Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
