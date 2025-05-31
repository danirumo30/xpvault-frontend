import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/desktop/profile_desktop.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_build_section_title.dart';
import 'package:xpvault/widgets/my_textformfield.dart';

class HomeDesktopPage extends StatefulWidget {
  const HomeDesktopPage({super.key});

  @override
  State<HomeDesktopPage> createState() => _HomeDesktopPageState();
}

class _HomeDesktopPageState extends State<HomeDesktopPage> {
  List<Game> featuredGames = [];
  List<Movie> popularMovies = [];
  List<Serie> popularSeries = [];
  User? _user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContentSequentially();
  }

  Future<void> loadContentSequentially() async {
    final user = await UserManager.getUser();
    print("${user?.username}");
    final gameController = GameController();
    final movieController = MovieController();
    final serieController = SerieController();

    final games = await gameController.fetchFeaturedGames();
    final movies = await movieController.getPopularMovies();
    final series = await serieController.fetchPopularSeries();

    setState(() {
      _user = user;
      featuredGames = games.toList();
      popularMovies = movies.toList();
      popularSeries = series.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 24, right: 32, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 600,
                  height: 40,
                  child: MyTextformfield(
                    hintText: "Search friends 🔍",
                    obscureText: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Row(
                    children: [
                      if (_user != null)
                        Text(
                          _user!.username,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(width: 12),
                      _user != null && _user!.profilePhoto != null && _user!.profilePhoto!.isNotEmpty
                          ? _HoverableProfileAvatar(
                        imageBytes: base64Decode(_user!.profilePhoto!),
                      )
                          : const _HoverableProfileAvatar(
                        imageBytes: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                children: [
                  const MyBuildSectionTitle(title: "🎮 Featured Games"),
                  MyBuildContentBox(items: featuredGames, showBodyLabel: false),

                  const SizedBox(height: 24),

                  const MyBuildSectionTitle(title: "🎬 Popular Movies"),
                  MyBuildContentBox(items: popularMovies, showBodyLabel: false),

                  const SizedBox(height: 24),

                  const MyBuildSectionTitle(title: "📺 Popular Series"),
                  MyBuildContentBox(items: popularSeries, showBodyLabel: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableProfileAvatar extends StatefulWidget {
  final Uint8List? imageBytes;

  const _HoverableProfileAvatar({Key? key, this.imageBytes}) : super(key: key);

  @override
  State<_HoverableProfileAvatar> createState() => _HoverableProfileAvatarState();
}

class _HoverableProfileAvatarState extends State<_HoverableProfileAvatar> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileDesktopPage()),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _hovering ? 56 : 48,
          height: _hovering ? 56 : 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: widget.imageBytes != null
                ? DecorationImage(
              image: MemoryImage(widget.imageBytes!),
              fit: BoxFit.cover,
            )
                : null,
            color: widget.imageBytes == null ? AppColors.surface : null,
          ),
          alignment: Alignment.center,
          child: widget.imageBytes == null
              ? const Text("👤", style: TextStyle(fontSize: 24))
              : null,
        ),
      ),
    );
  }
}
