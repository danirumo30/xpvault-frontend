import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/screens/playstation.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/build_bullet.dart';
import 'package:xpvault/widgets/my_imagecontainer.dart';

class HomeDesktopPage extends StatelessWidget {
  const HomeDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome to XPVault",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Your all-in-one hub for gaming and digital entertainment.",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "With XPVault, you can:",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 12),
                              BuildBullet(
                                text:
                                    "Link and manage accounts from Steam and PSN.",
                              ),
                              BuildBullet(
                                text:
                                    "Track gameplay stats, hours, and achievements.",
                              ),
                              BuildBullet(
                                text:
                                    "Organize your favorite movies and series.",
                              ),
                              BuildBullet(
                                text: "Compare progress with friends.",
                              ),
                              BuildBullet(
                                text:
                                    "Control your privacy while enjoying full access.",
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Get started now and take control of your digital universe!",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Get started with...",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 16),
                              MyImageContainer(
                                title: "Movies and series",
                                body: "Login or sign up to start",
                                image: "assets/movies.jpg",
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MoviesSeriesPage(),)),
                              ),
                              MyImageContainer(
                                title: "Steam",
                                body:"Login to your Steam account and get started",
                                image: "assets/steam.jpg",
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SteamPage(),)),
                              ),
                              MyImageContainer(
                                title: "Playstation",
                                body:"Login to your Playstation account and get started",
                                image: "assets/playstation.jpg",
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlaystationPage(),)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
