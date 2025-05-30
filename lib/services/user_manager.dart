import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpvault/models/steamUser.dart';
import '../models/user.dart';

class UserManager {
  static const _userKey = 'user_data';

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
  final updatedSteamUser = user.steamUser?.copyWith(steamId: steamId) ??
      SteamUser(steamId: steamId);

  final updatedUser = user.copyWith(
    steamUser: updatedSteamUser,
  );

  await saveUser(updatedUser);
}


}
