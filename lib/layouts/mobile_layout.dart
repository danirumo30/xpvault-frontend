import 'package:flutter/material.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/screens/signup.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/main_menu.dart';

class MobileLayout extends StatelessWidget {
  final String title;
  final Widget? body;

  const MobileLayout({super.key, required this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.redAccent,
        actions: [
          Row(
            children: [
              Icon(Icons.login),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.app_registration),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage(),));
                },
                child: Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(backgroundColor: AppColors.secondary,child: MainMenuWidget(),),
      backgroundColor: AppColors.secondary,
      body: body,
    );
  }
}