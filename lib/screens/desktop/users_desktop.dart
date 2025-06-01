import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/profile.dart';
import 'package:xpvault/themes/app_color.dart';

class UserSearchDesktopPage extends StatefulWidget {
  final String? initialSearchTerm;

  const UserSearchDesktopPage({Key? key, this.initialSearchTerm}) : super(key: key);

  @override
  State<UserSearchDesktopPage> createState() => _UserSearchDesktopPageState();
}

class _UserSearchDesktopPageState extends State<UserSearchDesktopPage> {
  final UserController _userController = UserController();
  bool _loading = true;

  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  int _currentPage = 0;
  static const int _usersPerPage = 20;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchTerm != null) {
      _searchController.text = widget.initialSearchTerm!;
    }
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
    });

    List<User> users = await _userController.getAllUsers();

    setState(() {
      _allUsers = users;
      _applyFilter(_searchController.text);
      _loading = false;
      _currentPage = 0;
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      if (filter.isEmpty) {
        _filteredUsers = List.from(_allUsers);
      } else {
        _filteredUsers = _allUsers.where((user) =>
            user.username.toLowerCase().contains(filter.toLowerCase())).toList();
      }
      _currentPage = 0;
    });
  }

  String _getTimeLabel(User user) {
    final minutes = user.totalTimePlayed + user.totalTimeEpisodesWatched + user.totalTimeMoviesWatched;
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return "$hours h ${remainingMinutes.toString().padLeft(2, '0')} min";
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (_filteredUsers.length / _usersPerPage).ceil();
    final int startIndex = _currentPage * _usersPerPage;
    final int endIndex = (_currentPage + 1) * _usersPerPage;
    final List<User> currentUsers = _filteredUsers.sublist(
      startIndex,
      endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex,
    );

    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Buscar usuarios...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) => _applyFilter(value),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : currentUsers.isEmpty
                  ? const Center(
                child: Text(
                  "No se encontraron usuarios",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.separated(
                itemCount: currentUsers.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                itemBuilder: (context, index) {
                  final user = currentUsers[index];
                  return _buildUserTile(user, startIndex + index + 1);
                },
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Anterior"),
                ),
                const SizedBox(width: 16),
                Text(
                  "Página ${_currentPage + 1} de $totalPages",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (_currentPage + 1) < totalPages
                      ? () => setState(() => _currentPage++)
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Siguiente"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(User user, int rank) {
    bool isHovering = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: AnimatedScale(
            scale: isHovering ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.surface,
                backgroundImage: (user.profilePhoto != null && user.profilePhoto!.isNotEmpty)
                    ? MemoryImage(base64Decode(user.profilePhoto!))
                    : null,
                child: (user.profilePhoto == null || user.profilePhoto!.isEmpty)
                    ? const Icon(
                  Icons.person,
                  color: Colors.white,
                )
                    : null,
              ),
              title: Text(
                "#$rank  ${user.username}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                _getTimeLabel(user),
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(
                      username: user.username,
                      steamId: user.steamUser?.steamId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
