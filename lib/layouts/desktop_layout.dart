import 'package:flutter/material.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/screens/signup.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/main_menu.dart';

class DesktopLayout extends StatefulWidget {
  final String title;
  final Widget? body;

  const DesktopLayout({super.key, required this.title, this.body});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await TokenManager.getToken();
    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  Future<void> _logout() async {
    await TokenManager.deleteToken();
    await UserManager.deleteUser();
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        backgroundColor: AppColors.primary,
        actions: [
          if (_isLoggedIn)
            Row(
              children: [
                const Icon(Icons.logout, color: Colors.white),
                TextButton(
                  onPressed: _logout,
                  child: const Text("Logout", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          else ...[
            Row(
              children: [
                const Icon(Icons.login, color: Colors.white),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.app_registration, color: Colors.white),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text("Sign up", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: AppColors.secondary,
        child: const MainMenuWidget(),
      ),
      backgroundColor: AppColors.secondary,
      body: widget.body,
    );
  }
}
