import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/screens/user_settings.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_build_section_title.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/services/user_manager.dart';

class ProfileDesktopPage extends StatefulWidget {
  const ProfileDesktopPage({super.key});

  @override
  State<ProfileDesktopPage> createState() => _ProfileDesktopPageState();
}

class _ProfileDesktopPageState extends State<ProfileDesktopPage> {
  User? _user;
  final GameController _gameController = GameController();
  bool _isLoadingMyGames = true;
  bool _isSteamUser = false;
  List<Game> myGames = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadMyGames();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserManager.getUser();
    setState(() {
      _user = loadedUser;
    });
  }

  Future<void> _loadMyGames() async {
    late List<Game> loadedGames = [];
    final currentUser = await UserManager.getUser();

    if (currentUser?.steamId != null) {
      _isSteamUser = true;
    }

    setState(() {
      _isLoadingMyGames = true;
    });

    if (_isSteamUser) {
      loadedGames = await _gameController.getUserGames(currentUser?.steamId);
    }

    setState(() {
      myGames = loadedGames;
      _isLoadingMyGames = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: _user == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: AppColors.accent, size: 45),
                  SizedBox(height: 16),
                  Text(
                    "You need to log in to access the profile",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _user!.username,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserSettingsPage(user: _user,),));
                            },
                            child: const CircleAvatar(
                              backgroundColor: AppColors.surface,
                              radius: 44,
                              backgroundImage: AssetImage("assets/steam.jpg"),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatsCard("🎮", "Hours in Games", 124),
                        _buildStatsCard("🎬", "Hours in Movies", 56),
                        _buildStatsCard("📺", "Hours in Series", 78),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Expanded(
                      child: ListView(
                        children: const [
                          MyBuildSectionTitle(title: "🎮 My Games"),
                          //MyBuildContentBox(),

                          SizedBox(height: 24),

                          MyBuildSectionTitle(title: "🎬 My Movies"),
                          //MyBuildContentBox(),

                          SizedBox(height: 24),

                          MyBuildSectionTitle(title: "📺 My Series"),
                          //MyBuildContentBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsCard(String emoji, String label, int hours) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              "$hours h",
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
