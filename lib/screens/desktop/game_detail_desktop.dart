import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/news.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/themes/app_color.dart';

class GameDetailDesktopPage extends StatefulWidget {
  final int steamId;

  const GameDetailDesktopPage({super.key, required this.steamId});

  @override
  State<GameDetailDesktopPage> createState() => _GameDetailDesktopPageState();
}

class _GameDetailDesktopPageState extends State<GameDetailDesktopPage> {
  final GameController _gameController = GameController();

  Game? _game;
  bool _isLoadingGame = true;
  bool _searchingNews = true;
  List<News> gameNews = [];
  final List<bool> _hovering = [];
  final List<bool> _hoveringAchievements = [];

  @override
  void initState() {
    super.initState();
    _loadGameAndNews();
  }

  Future<void> _loadGameAndNews() async {
    final game = await _gameController.getGameBySteamId(widget.steamId);
    if (game != null) {
      final news = await _gameController.getGameNewsById(widget.steamId);

      setState(() {
        _game = game;
        _isLoadingGame = false;
        gameNews = news;
        _hovering.addAll(List.generate(news.length, (_) => false));
        _hoveringAchievements.addAll(List.generate(game.achievements?.length ?? 0, (_) => false));
        _searchingNews = false;
      });
    } else {
      setState(() {
        _isLoadingGame = false;
        _searchingNews = false;
      });
    }
  }

  String resolveImageUrl(String? url) {
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

    if (url == null || url.trim().isEmpty) {
      return defaultImage;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingGame) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_game == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Game not found",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ),
      );
    }

    final imageUrl = resolveImageUrl(_game!.headerUrl);

    return DesktopLayout(
      title: "XPVAULT",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 320,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, size: 64, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Game Title
            Text(
              _game!.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              _game!.description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 16),

            // Price
            Text(
              "Price: \$${_game!.price.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 32),

            // Tags
            Text(
              "Tags",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _game!.genres
                  .map(
                    (tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
                  .toList(),
            ),

            const SizedBox(height: 36),

            // Achievements with hover and spacing
            Text(
              "Achievements",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            (_game!.achievements == null || _game!.achievements!.isEmpty)
                ? Text(
              "No achievements available.",
              style: TextStyle(color: AppColors.textSecondary),
            )
                : Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _game!.achievements!.asMap().entries.map((entry) {
                final index = entry.key;
                final achievement = entry.value;
                final imageUrl = _gameController.proxiedSteamImage(achievement.url);
                final isHovered = _hoveringAchievements[index];

                return MouseRegion(
                  onEnter: (_) {
                    setState(() => _hoveringAchievements[index] = true);
                  },
                  onExit: (_) {
                    setState(() => _hoveringAchievements[index] = false);
                  },
                  child: AnimatedScale(
                    scale: isHovered ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                              onError: (error, stackTrace) {
                                debugPrint('Image load error: $error');
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 96,
                          child: Text(
                            achievement.name,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 36),

            // News
            Text(
              "News",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_searchingNews)
              const Center(child: CircularProgressIndicator())
            else if (gameNews.isEmpty)
              Text(
                "No news found.",
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              Column(
                children: gameNews.asMap().entries.map((entry) {
                  final index = entry.key;
                  final newsItem = entry.value;
                  final isHovered = _hovering[index];

                  return MouseRegion(
                    onEnter: (_) {
                      setState(() => _hovering[index] = true);
                    },
                    onExit: (_) {
                      setState(() => _hovering[index] = false);
                    },
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        final uri = Uri.tryParse(newsItem.url.trim());
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: AnimatedScale(
                        scale: isHovered ? 1.02 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[900],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                newsItem.contents,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 40),

            // Back Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SteamPage()),
                  );
                },
                child: const Text(
                  "Go Back",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
