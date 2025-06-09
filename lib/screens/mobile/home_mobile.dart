import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:web/web.dart' as web;

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/basic_user.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/profile.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_textformfield.dart';

class HomeMobilePage extends StatefulWidget {
  const HomeMobilePage({super.key});

  @override
  State<HomeMobilePage> createState() => _HomeMobilePage();
}

class _HomeMobilePage extends State<HomeMobilePage> {
  List<Game> featuredGames = [];
  List<Movie> popularMovies = [];
  List<Serie> popularSeries = [];
  User? _user;
  final UserController _userController = UserController();

  bool isLoading = true;
  bool _isSteamLoggedIn = false;
  String _token = "";

  final TextEditingController _searchController = TextEditingController();
  List<BasicUser> _allUsers = [];
  List<BasicUser> _filteredUsers = [];
  bool _loadingUsers = true;

  @override
  void initState() {
    super.initState();
    _initAsync();
    _searchController.addListener(() {
      _applyUserFilter(_searchController.text);
    });
  }

  Future<void> _initAsync() async {
    await handleSteamLogin();
    await loadContentSequentially();
    await loadUsers();
  }

  Future<void> handleSteamLogin() async {
    final search = web.window.location.search;
    final uri = Uri.parse(search.isNotEmpty ? search : '');
    final steamId = uri.queryParameters['steamId'];

    if (steamId != null && steamId.isNotEmpty && !_isSteamLoggedIn) {
      setState(() => _isSteamLoggedIn = true);
      await UserManager.assignSteamIdToUser(steamId);

      var user = await UserManager.getUser();
      if (user != null) {
        setState(() => _user = user);
        final token = await TokenManager.getToken();
        if (token != null) {
          setState(() => _token = token);
          final saved = await _userController.saveUser(user, _token);

          if (saved) {
            final updatedUser = await _userController.getUserByUsername(user.username);
            if (updatedUser != null) {
              await UserManager.saveUser(updatedUser);
              setState(() => _user = updatedUser);

              Future.microtask(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(updatedUser.steamUser != null
                        ? "Steam account successfully linked"
                        : "Could not link Steam account because another XPVault user already has this Steam user assigned."),
                    backgroundColor: updatedUser.steamUser != null ? Colors.green : Colors.red,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 4),
                  ),
                );
              });
            }
          }
        }
      }
      web.window.history.replaceState(null, '', '/');
    } else if (search.isNotEmpty && (steamId == null || steamId.isEmpty)) {
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Steam ID found in URL. Unable to link Steam account."),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      });
    }
  }

  Future<void> loadContentSequentially() async {
    final user = await UserManager.getUser();
    final gameController = GameController();
    final movieController = MovieController();
    final serieController = SerieController();

    final games = await gameController.fetchFeaturedGames();
    final movies = await movieController.getPopularMovies();
    final series = await serieController.fetchTopRatedSeries();

    setState(() {
      _user = user;
      featuredGames = games.toList();
      popularMovies = movies.toList();
      popularSeries = series.toList();
      isLoading = false;
    });
  }

  Future<void> loadUsers() async {
    setState(() => _loadingUsers = true);
    List<BasicUser> users = await _userController.getAllUsers();
    setState(() {
      _allUsers = users;
      _filteredUsers = [];
      _loadingUsers = false;
    });
  }

  void _applyUserFilter(String filter) {
    setState(() {
      _filteredUsers = filter.isEmpty
          ? []
          : _allUsers.where((user) => user.nickname.toLowerCase().contains(filter.toLowerCase())).toList();
    });
  }

  String _getTimeLabel(BasicUser user) {
    final minutes = user.totalTime;
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return "$hours h ${remainingMinutes.toString().padLeft(2, '0')} min";
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MobileLayout(
        title: "XPVAULT",
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 34),
                Row(
                  children: [
                    Expanded(
                      child: MyTextformfield(
                        textEditingController: _searchController,
                        hintText: "Search friends...",
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(width: 5),
                    _HoverableProfileAvatar(
                      imageBytes: _user?.profilePhoto != null
                          ? base64Decode(_user!.profilePhoto!)
                          : null,
                      nickname: _user?.username,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_loadingUsers)
                  const Center(child: CircularProgressIndicator(color: AppColors.accent))
                else if (_searchController.text.isNotEmpty)
                  _filteredUsers.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("No users found", style: TextStyle(color: Colors.white)),
                  )
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(_filteredUsers.length, 5),
                    separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.surface,
                          backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                              ? MemoryImage(base64Decode(user.photoUrl!))
                              : null,
                          child: user.photoUrl == null || user.photoUrl!.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        title: Text(user.nickname,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        subtitle: Text(_getTimeLabel(user),
                            style: const TextStyle(color: Colors.white70)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(username: user.nickname),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(height: 24),
                isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyBuildContentBox(
                      items: featuredGames,
                      showBodyLabel: false,
                      returnPage: HomePage(),
                      title: "🎮 Featured Games",
                    ),
                    const SizedBox(height: 24),
                    MyBuildContentBox(
                      items: popularMovies,
                      showBodyLabel: false,
                      returnPage: HomePage(),
                      title: "🎬 Popular Movies",
                    ),
                    const SizedBox(height: 24),
                    MyBuildContentBox(
                      items: popularSeries,
                      showBodyLabel: false,
                      returnPage: HomePage(),
                      title: "📺 Popular Series",
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverableProfileAvatar extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? nickname;

  const _HoverableProfileAvatar({
    Key? key,
    this.imageBytes,
    this.nickname,
  }) : super(key: key);

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
          if (widget.nickname != null && widget.nickname!.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(username: widget.nickname!),
              ),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _hovering ? 48 : 40,
          height: _hovering ? 48 : 40,
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
              ? const Text("👤", style: TextStyle(fontSize: 20))
              : null,
        ),
      ),
    );
  }
}
