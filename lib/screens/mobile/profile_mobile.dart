import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/profile.dart';
import 'package:xpvault/screens/user_settings.dart';
import 'package:xpvault/screens/users.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_stats_card.dart';
import 'package:xpvault/layouts/mobile_layout.dart';

class ProfileMobilePage extends StatefulWidget {
  final String? username;
  final String? steamId;

  const ProfileMobilePage({super.key, this.username, this.steamId});

  @override
  State<ProfileMobilePage> createState() => _ProfileMobilePageState();
}

class _ProfileMobilePageState extends State<ProfileMobilePage> {
  final _gameController = GameController();
  final _movieController = MovieController();
  final _serieController = SerieController();
  final _userController = UserController();

  User? _user;
  List<Game> _games = [];
  List<Movie> _movies = [];
  List<Serie> _series = [];

  bool _loading = true;
  bool _isFriend = false;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _loadUserAndContent();
  }

  Future<void> _loadUserAndContent() async {
    setState(() => _loading = true);

    final loadedUser = widget.username == null
        ? await UserManager.getUser()
        : await UserManager.getUserByUsername(widget.username!);

    if (!mounted) return;

    if (loadedUser == null) {
      setState(() {
        _user = null;
        _loading = false;
      });
      return;
    }

    _user = loadedUser;

    final currentUser = await UserManager.getUser();
    if (!mounted) return;

    _currentUsername = currentUser?.username;

    if (_currentUsername != null && _currentUsername != _user!.username) {
      _isFriend = await _userController.isFriend(_currentUsername!, _user!.username);
    } else {
      _isFriend = false;
    }

    final games = widget.steamId != null
        ? await _gameController.getTenUserGames(widget.steamId!)
        : (_user!.steamUser != null
            ? await _gameController.getTenUserGames(_user!.steamUser!.steamId)
            : []).cast<Game>();

    final movies = await _movieController.fetchUserMovies(_user!.username);
    final series = await _serieController.fetchUserSeries(_user!.username);

    if (!mounted) return;

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
      return const MobileLayout(
        title: "XPVAULT",
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_user == null) {
      return const MobileLayout(
        title: "XPVAULT",
        body: Center(
          child: Text(
            "You need to log in to access the profile",
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return MobileLayout(
      title: "XPVAULT",
      body: RefreshIndicator(
        onRefresh: _loadUserAndContent,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Header: Avatar + Nombre + Acción
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final current = await UserManager.getUser();
                    if (current?.username == _user!.username) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserSettingsPage(user: _user),
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
                    backgroundImage: (_user!.profilePhoto?.isNotEmpty ?? false)
                        ? MemoryImage(base64Decode(_user!.profilePhoto!))
                        : null,
                    child: (_user!.profilePhoto?.isEmpty ?? true)
                        ? const Text("👤", style: TextStyle(fontSize: 28))
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _user!.username,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_currentUsername != null && _currentUsername != _user!.username)
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: _isFriend ? Colors.lightGreenAccent : Colors.grey,
                    ),
                    onPressed: () async {
                      final current = await UserManager.getUser();
                      if (current == null) return;

                      final success = _isFriend
                          ? await _userController.deleteFriendFromUser(current.username, _user!.username)
                          : await _userController.addFriend(current.username, _user!.username);

                      if (success) {
                        setState(() => _isFriend = !_isFriend);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isFriend ? "Friend added!" : "Friend removed!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Something went wrong"),
                            backgroundColor: AppColors.warning,
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Estadísticas
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                MyStatsCard(
                  title: "🎮 Hours played",
                  value: _user!.totalTimePlayed,
                  isTime: true,
                ),
                MyStatsCard(
                  title: "🎬 Movie hours",
                  value: _user!.totalTimeMoviesWatched,
                  isTime: true,
                ),
                MyStatsCard(
                  title: "📺 Series hours",
                  value: _user!.totalTimeEpisodesWatched,
                  isTime: true,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UsersPage(
                          initialSearchTerm: "",
                          viewFriendsOf: _user!.username,
                        ),
                      ),
                    );
                  },
                  child: MyStatsCard(
                    title: "👥 Friends",
                    value: _user!.totalFriends,
                    isTime: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Contenido
            MyBuildContentBox(
              items: _games,
              title: "🎮 My Games",
              username: _user!.steamUser?.steamId,
              returnPage: ProfilePage(username: widget.username!),
            ),
            const SizedBox(height: 32),

            MyBuildContentBox(
              items: _movies,
              title: "🎬 My Movies",
              username: _user!.username,
              returnPage: ProfilePage(username: widget.username!),
            ),
            const SizedBox(height: 32),

            MyBuildContentBox(
              items: _series,
              title: "📺 My Series",
              username: _user!.username,
              returnPage: ProfilePage(username: widget.username!),
            ),
          ],
        ),
      ),
    );
  }
}
