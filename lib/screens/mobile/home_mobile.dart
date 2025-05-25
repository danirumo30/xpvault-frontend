import 'package:flutter/material.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/screens/playstation.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_imagecontainer.dart';
import 'package:xpvault/widgets/my_textformfield.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return MobileLayout(
      title: "XPVAULT",
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Search for users",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    hintText: "Search...",
                    obscureText: false,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Get started with",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 20),
            MyImageContainer(
              title: "Movies and Series",
              body: "Login or sign up to start exploring",
              image: "assets/movies.jpg",
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MoviesSeriesPage()),
              ),
            ),
            const SizedBox(height: 16),
            MyImageContainer(
              title: "Steam",
              body: "Login to your Steam account and get started",
              image: "assets/steam.jpg",
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SteamPage()),
              ),
            ),
            const SizedBox(height: 16),
            MyImageContainer(
              title: "Playstation",
              body: "Login to your Playstation account and get started",
              image: "assets/playstation.jpg",
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PlaystationPage()),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
