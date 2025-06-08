import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/top_user.dart';
import 'package:xpvault/screens/profile.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';

class RankingMobilePage extends StatefulWidget {
  const RankingMobilePage({super.key});

  @override
  State<RankingMobilePage> createState() => _RankingMobilePageState();
}

enum RankingType { games, movies, series }

class _RankingMobilePageState extends State<RankingMobilePage> {
  RankingType _currentType = RankingType.movies;
  final UserController _userController = UserController();

  bool _loading = true;
  List<TopUser> _users = [];

  int _currentPage = 0;
  static const int _usersPerPage = 20;

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
        users = await _userController.getTopGames();
    }

    await UserManager.saveTopUsers(users);

    setState(() {
      _users = users;
      _currentPage = 0;
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
    final int totalPages = (_users.length / _usersPerPage).ceil();
    final int startIndex = _currentPage * _usersPerPage;
    final int endIndex = (_currentPage + 1) * _usersPerPage;
    final List<TopUser> currentUsers = _users.sublist(
      startIndex,
      endIndex > _users.length ? _users.length : endIndex,
    );

    return MobileLayout(
      title: "XPVAULT",
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : Column(
              children: [
                const SizedBox(height: 16),
                _buildFilterBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: currentUsers.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final user = currentUsers[index];
                      return _buildUserTile(user, startIndex + index + 1);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _buildPaginationControls(totalPages),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: [
          _buildFilterButton("🎬 Movies", RankingType.movies),
          _buildFilterButton("📺 Series", RankingType.series),
          _buildFilterButton("🎮 Games", RankingType.games),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, RankingType type) {
    final isSelected = _currentType == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.accent : AppColors.surface,
        foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: () => _changeType(type),
      child: Text(label),
    );
  }

  Widget _buildUserTile(TopUser user, int rank) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.surface,
        backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
            ? MemoryImage(base64Decode(user.photoUrl!))
            : null,
        child: (user.photoUrl == null || user.photoUrl!.isEmpty)
            ? const Icon(Icons.person, color: AppColors.textSecondary)
            : null,
      ),
      title: Text(
        "#$rank  ${user.nickname}",
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(username: user.nickname),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
        ),
        Text(
          "Page ${_currentPage + 1} of $totalPages",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: (_currentPage + 1) < totalPages
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }
}
