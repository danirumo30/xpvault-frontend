import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/build_bullet.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/redirect_message.dart';

class ProfileDesktopPage extends StatefulWidget {
  const ProfileDesktopPage({super.key});

  @override
  State<ProfileDesktopPage> createState() => _ProfileDesktopPageState();
}

class _ProfileDesktopPageState extends State<ProfileDesktopPage> {
  User? _user;
  TextEditingController steamController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserManager.getUser();
    setState(() {
      _user = loadedUser;
    });
  }

  Future<void> _logout() async {
    await TokenManager.deleteToken();
    await UserManager.deleteUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return DesktopLayout(
      title: "XPVAULT",
      body:
          _user == null
              ? Center(
                child: const Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.accent),
                    Text(
                      "You need to log in to access the profile",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: screenHeight * 0.8,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User Profile",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Manage your account and view your statistics",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Account information",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BuildBullet(
                                  text: "Username: ${_user!.username}",
                                ),
                                BuildBullet(text: "Email: ${_user!.email}"),
                                const SizedBox(height: 12),
                                Text(
                                  "Hours spent",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                BuildBullet(
                                  text: "Hours in movies and series: 0h",
                                ),
                                BuildBullet(text: "Hours in Steam: 0h"),
                                BuildBullet(
                                  text: "Hours in Playstation: coming soon...",
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Others",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                RedirectMessage(
                                  mainText: "Want to change the password? ",
                                  linkText: "Click here!",
                                ),
                                RedirectMessage(
                                  mainText: "Want to change user? ",
                                  linkText: "Logout",
                                  onTap: () {
                                    _logout();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: screenHeight * 0.8,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Steam",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                BuildBullet(
                                  text:
                                      "To log in with your Steam account, you must have a personalized URL.\nThe steps are: Login to Steam -> View my profile -> Modify profile -> Custom URL -> Enter username.",
                                ),
                                MyTextformfield(
                                  hintText: "Custom URL",
                                  obscureText: false,
                                  textEditingController: steamController,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (await UserController().getSteamUserId(steamController.text,) == 200) {
                                        ScaffoldMessenger.of(context,).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Steam account successfully linked",
                                            ),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context,).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Steam account linked without success",
                                            ),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      Icons.app_registration_rounded,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Friends",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
