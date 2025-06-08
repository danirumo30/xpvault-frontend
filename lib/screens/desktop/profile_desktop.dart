import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
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
  final UserController _userController = UserController();

  User? _user;
  List<Game> _games = [];
  List<Movie> _movies = [];
  List<Serie> _series = [];

  bool _hoveringTick = false;
  bool _hoveringFriends = false;
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

    User? loadedUser;
    if (widget.username == null) {
      loadedUser = await UserManager.getUser();
    } else {
      loadedUser = await UserManager.getUserByUsername(widget.username!);
    }

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

    if (!mounted) return;

    List<Game> games = [];
    if (widget.steamId != null) {
      games = await _gameController.getTenUserGames(widget.steamId);
    } else if (loadedUser.steamUser != null) {
      games = await _gameController.getTenUserGames(loadedUser.steamUser!.steamId);
    }

    final movies = await _movieController.fetchUserMovies(loadedUser.username);
    final series = await _serieController.fetchUserSeries(loadedUser.username);

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

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      MyStatsCard(
                        title: "🎮 Hours played",
                        value: _user!.totalTimePlayed,
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
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hoveringFriends = true),
                        onExit: (_) => setState(() => _hoveringFriends = false),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsersPage(
                                  initialSearchTerm: "",
                                  viewFriendsOf: _user!.username,
                                ),
                              ),
                            );
                          },
                          child: AnimatedScale(
                            scale: _hoveringFriends ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: MyStatsCard(
                              title: "👥 Friends",
                              value: _user!.totalFriends,
                              isTime: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_currentUsername != null && _currentUsername != _user!.username)
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _hoveringTick = true),
                      onExit: (_) => setState(() => _hoveringTick = false),
                      child: GestureDetector(
                        onTap: () async {
                          bool success;
                          final currentUsername = (await UserManager.getUser())?.username;

                          if (currentUsername == null) {
                            print('Error: No se pudo obtener el usuario actual');
                            return;
                          }

                          if (_isFriend) {
                            success = await _userController.deleteFriendFromUser(currentUsername, _user!.username);
                          } else {
                            success = await _userController.addFriend(currentUsername, _user!.username);
                          }

                          if (success) {
                            setState(() {
                              _isFriend = !_isFriend;
                              _loading = true;
                            });

                            await _loadUserAndContent();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _isFriend ? "Friend added!" : "Friend removed!",
                                ),
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
                        child: AnimatedScale(
                          scale: _hoveringTick ? 1.3 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isFriend ? Colors.lightGreenAccent : Colors.grey,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),

            Expanded(
              child: ListView(
                children: [
                  MyBuildContentBox(items: _games, title: "🎮 My Games", returnPage: ProfilePage(username: widget.username!),),
                  const SizedBox(height: 45),

                  MyBuildContentBox(items: _movies, title: "🎬 My Movies", username: _user!.username, returnPage: ProfilePage(username: widget.username!),),
                  const SizedBox(height: 45),

                  MyBuildContentBox(items: _series, title: "📺 My Series", username: _user!.username, returnPage: ProfilePage(username: widget.username!),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}