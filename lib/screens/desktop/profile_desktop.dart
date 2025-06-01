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
import 'package:xpvault/screens/user_settings.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_build_section_title.dart';
import 'package:xpvault/widgets/my_stats_card.dart';

class ProfileDesktopPage extends StatefulWidget {
  final String? username;
  final String? steamId;

  const ProfileDesktopPage({super.key, this.username, this.steamId});

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
    if (widget.steamId != null) {
      games = await _gameController.getUserGames(widget.steamId);
    } else if (loadedUser.steamUser != null && widget.username == null) {
      games = await _gameController.getUserGames(loadedUser.steamUser!.steamId);
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
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_user == null) {
      return const DesktopLayout(
        title: "XPVAULT",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: AppColors.accent, size: 45),
              SizedBox(height: 16),
              Text(
                "You need to log in to access the profile",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20),
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
            // Usuario con avatar y nombre
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      final currentUser = await UserManager.getUser();
                      if (currentUser != null &&
                          currentUser.username == _user!.username) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSettingsPage(user: _user),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You can only edit your own profile"),
                            backgroundColor: AppColors.warning,
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.surface,
                      backgroundImage:
                          (_user!.profilePhoto != null &&
                                  _user!.profilePhoto!.isNotEmpty)
                              ? MemoryImage(base64Decode(_user!.profilePhoto!))
                              : null,
                      child:
                          (_user!.profilePhoto == null ||
                                  _user!.profilePhoto!.isEmpty)
                              ? const Text("👤", style: TextStyle(fontSize: 28))
                              : null,
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

            // Estadísticas
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                MyStatsCard(
                  title: "🎮 Hours played",
                  value: _user!.steamUser?.totalTimePlayed ?? 0,
                  isTime: true,
                ),
                MyStatsCard(
                  title: "🎬 Hours watched in movies",
                  value: _user!.totalTimeMoviesWatched,
                  isTime: true,
                ),
                MyStatsCard(
                  title: "📺 Hours watched in series",
                  value: _user!.totalTimeEpisodesWatched,
                  isTime: true,
                ),
                MyStatsCard(title: "👥 Friends", value: 0, isTime: false),
              ],
            ),
            const SizedBox(height: 32),

            // Contenido
            Expanded(
              child: ListView(
                children: [
                  const MyBuildSectionTitle(title: "🎮 My Games"),
                  MyBuildContentBox(items: _games),
                  const SizedBox(height: 24),

                  const MyBuildSectionTitle(title: "🎬 My Movies"),
                  MyBuildContentBox(items: _movies),
                  const SizedBox(height: 24),

                  const MyBuildSectionTitle(title: "📺 My Series"),
                  MyBuildContentBox(items: _series),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
