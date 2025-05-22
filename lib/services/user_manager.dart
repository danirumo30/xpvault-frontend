import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpvault/controllers/user_controller.dart';
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

  static Future<void> assignSteamIdToUser(int steamId) async {
  try {
    final currentUser = await UserManager.getUser();

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(steamId: steamId);
      await UserManager.saveUser(updatedUser);
      print("Steam ID $steamId asignado al usuario ${updatedUser.username}");
    } else {
      print("No hay usuario guardado para actualizar.");
    }
  } catch (e) {
    print("Error al asignar Steam ID: $e");
  }
}

}
