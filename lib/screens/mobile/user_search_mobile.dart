import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/basic_user.dart';
import 'package:xpvault/screens/profile.dart';
import 'package:xpvault/themes/app_color.dart';

class UserSearchMobilePage extends StatefulWidget {
  final String? initialSearchTerm;
  final String? viewFriendsOf;

  const UserSearchMobilePage({
    Key? key,
    this.initialSearchTerm,
    this.viewFriendsOf,
  }) : super(key: key);

  @override
  State<UserSearchMobilePage> createState() => _UserSearchMobilePageState();
}

class _UserSearchMobilePageState extends State<UserSearchMobilePage> {
  final UserController _userController = UserController();
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  List<BasicUser> _allUsers = [];
  List<BasicUser> _filteredUsers = [];

  int _currentPage = 0;
  static const int _usersPerPage = 10;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchTerm != null) {
      _searchController.text = widget.initialSearchTerm!;
    }
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    List<BasicUser> users;

    if (widget.viewFriendsOf != null) {
      users = await _userController.fetchUserFriends(widget.viewFriendsOf!);
    } else {
      users = await _userController.getAllUsers();
    }

    setState(() {
      _allUsers = users;
      if (widget.viewFriendsOf == null) {
        _applyFilter(_searchController.text);
      } else {
        _filteredUsers = users;
      }
      _loading = false;
      _currentPage = 0;
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      if (filter.isEmpty) {
        _filteredUsers = List.from(_allUsers);
      } else {
        _filteredUsers = _allUsers
            .where((user) =>
                user.nickname.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      }
      _currentPage = 0;
    });
  }

  String _getTimeLabel(BasicUser user) {
    final minutes = user.totalTime;
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return "$hours h ${remainingMinutes.toString().padLeft(2, '0')} min";
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (_filteredUsers.length / _usersPerPage).ceil();
    final int startIndex = _currentPage * _usersPerPage;
    final int endIndex = (_currentPage + 1) * _usersPerPage;
    final List<BasicUser> currentUsers = _filteredUsers.sublist(
      startIndex,
      endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex,
    );

    return MobileLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.viewFriendsOf == null
                ? TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Find users...",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: _applyFilter,
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "${widget.viewFriendsOf}'s Friends",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : currentUsers.isEmpty
                      ? const Center(
                          child: Text(
                            "No users found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.separated(
                          itemCount: currentUsers.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Colors.white24),
                          itemBuilder: (context, index) {
                            final user = currentUsers[index];
                            return _buildUserTile(user, startIndex + index + 1);
                          },
                        ),
            ),
            const SizedBox(height: 12),
            if (!_loading && _filteredUsers.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _currentPage > 0
                        ? () => setState(() => _currentPage--)
                        : null,
                  ),
                  Text(
                    "Page ${_currentPage + 1} of $totalPages",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: (_currentPage + 1) < totalPages
                        ? () => setState(() => _currentPage++)
                        : null,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(BasicUser user, int rank) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: AppColors.surface,
        backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
            ? MemoryImage(base64Decode(user.photoUrl!))
            : null,
        child: (user.photoUrl == null || user.photoUrl!.isEmpty)
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(
        "#$rank  ${user.nickname}",
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
}
