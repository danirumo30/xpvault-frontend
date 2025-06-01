import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/models/steam_user.dart';
import 'package:xpvault/models/top_user.dart';
import '../models/user.dart';

class UserManager {
  static const _userKey = 'user_data';
  static const _topUsersKey = 'top_users';

  static final UserController _userController = UserController();

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    final userJson = jsonDecode(userString);
    return User.fromJson(userJson);
  }

  static Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<void> assignSteamIdToUser(String steamId) async {
    final user = await getUser();
    if (user == null) return;

    // Preservar datos existentes de SteamUser si ya hay uno
    final updatedSteamUser =
        user.steamUser?.copyWith(steamId: steamId) ??
        SteamUser(steamId: steamId);

    final updatedUser = user.copyWith(steamUser: updatedSteamUser);

    await saveUser(updatedUser);
  }

  static Future<User?> getUserByUsername(String username) async {
    return await _userController.getUserByUsername(username);
  }

  static Future<void> saveTopUsers(List<TopUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_topUsersKey, usersJson);
  }

  static Future<List<TopUser>> getTopUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJsonList = prefs.getStringList(_topUsersKey);
    if (usersJsonList == null) return [];
    return usersJsonList.map((jsonStr) {
      final jsonMap = jsonDecode(jsonStr);
      return TopUser.fromJson(jsonMap);
    }).toList();
  }
}
