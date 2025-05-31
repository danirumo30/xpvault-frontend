import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_build_section_title.dart';

class ProfileDesktopPage extends StatefulWidget {
  final String? username;

  const ProfileDesktopPage({super.key, this.username});

  @override
  State<ProfileDesktopPage> createState() => _ProfileDesktopPageState();
}

class _ProfileDesktopPageState extends State<ProfileDesktopPage> {
  final GameController _gameController = GameController();
  final MovieController _movieController = MovieController();
  final SerieController _serieController = SerieController();

  User? _user;
  List<Game> _games = [];
  List<Movie> _movies = [];
  List<Serie> _series = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserAndContent();
  }

  Future<void> _loadUserAndContent() async {
    setState(() => _loading = true);

    User? loadedUser;
    if (widget.username == null) {
      loadedUser = await UserManager.getUser();
    } else {
      loadedUser = await UserManager.getUserByUsername(widget.username!);
    }

    if (loadedUser == null) {
      setState(() {
        _user = null;
        _loading = false;
      });
      return;
    }

    _user = loadedUser;

    List<Game> games = [];
    if (loadedUser.steamId != null && loadedUser.steamId!.isNotEmpty) {
      games = (await _gameController.getTenUserGames(loadedUser.steamId!));
    }

    final movies = await _movieController.fetchUserMovies(loadedUser.username);
    final series = await _serieController.fetchUserSeries(loadedUser.username);

    setState(() {
      _games = games;
      _movies = movies;
      _series = series;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const DesktopLayout(
        title: "XPVAULT",
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return DesktopLayout(
        title: "XPVAULT",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: AppColors.accent, size: 45),
              const SizedBox(height: 16),
              Text(
                widget.username == null
                    ? "You need to log in to access the profile"
                    : "User '${widget.username}' not found",
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_user!.profilePhoto != null &&
                    _user!.profilePhoto!.isNotEmpty)
                     MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => UserSettingsPage(user: _user),
                            ),
                          ),
                      child:
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: MemoryImage(
                      base64Decode(_user!.profilePhoto!),
                    ),
                  )
                    )
                  )
                else
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => UserSettingsPage(user: _user),
                            ),
                          ),
                      child: const CircleAvatar(
                        backgroundColor: AppColors.surface,
                        radius: 36,
                        child: Text("👤", style: TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Text(
                  _user!.username,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildStatCard("🎮 Tiempo J", _user!.totalTimePlayed),
                _buildStatCard("🎬 Tiempo P", _user!.totalTimeMoviesWatched),
                _buildStatCard("📺 Tiempo S", _user!.totalTimeEpisodesWatched),
                _buildStatCard("👥 Amigos", _user!.totalFriends, isTime: false),
              ],
            ),
            const SizedBox(height: 32),

            Expanded(
              child: ListView(
                children: [
                  const MyBuildSectionTitle(title: "🎮 My Games"),
                  MyBuildContentBox(items: _games, showBodyLabel: false),
                  const SizedBox(height: 24),

                  const MyBuildSectionTitle(title: "🎬 My Movies"),
                  MyBuildContentBox(items: _movies, showBodyLabel: false),
                  const SizedBox(height: 24),

                  const MyBuildSectionTitle(title: "📺 My Series"),
                  MyBuildContentBox(items: _series, showBodyLabel: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, {bool isTime = true}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTime ? "$value h" : "$value",
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
