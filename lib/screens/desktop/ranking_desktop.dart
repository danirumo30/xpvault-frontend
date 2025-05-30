import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/top_user.dart';
import 'package:xpvault/themes/app_color.dart';

class RankingDesktopPage extends StatefulWidget {
  const RankingDesktopPage({super.key});

  @override
  State<RankingDesktopPage> createState() => _RankingDesktopPageState();
}

enum RankingType { games, movies, series }

class _RankingDesktopPageState extends State<RankingDesktopPage> {
  RankingType _currentType = RankingType.games;
  final UserController _userController = UserController();

  bool _loading = true;
  List<TopUser> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    List<TopUser> users;
    switch (_currentType) {
      case RankingType.movies:
        users = await _userController.getTopMovies();
        break;
      case RankingType.series:
        users = await _userController.getTopTvSeries();
        break;
      case RankingType.games:
      default:
        users = await _userController.getTopGames();
    }
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  void _changeType(RankingType type) {
    if (_currentType != type) {
      setState(() => _currentType = type);
      _loadUsers();
    }
  }

  String _getTimeLabel(TopUser user) {
    final minutes = user.totalTime;
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return "$hours h ${remainingMinutes.toString().padLeft(2, '0')} min";
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "🏆 Ranking",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterButton("🎮 Games", RankingType.games),
                    _buildFilterButton("🎬 Movies", RankingType.movies),
                    _buildFilterButton("📺 Series", RankingType.series),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.surface,
                      backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? MemoryImage(base64Decode(user.photoUrl!))
                          : null,
                      child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                          ? const Icon(Icons.person, color: AppColors.textSecondary)
                          : null,
                    ),
                    title: Text(
                      "#${index + 1}  ${user.nickname}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      _getTimeLabel(user),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, RankingType type) {
    final isSelected = _currentType == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.accent : AppColors.surface,
        foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => _changeType(type),
      child: Text(label),
    );
  }
}
