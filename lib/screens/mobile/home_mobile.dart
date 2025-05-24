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
    final screenHeight = MediaQuery.of(context).size.height;

    return MobileLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
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
                              Column(
                                spacing: 20,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Search for users",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 45,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  MyTextformfield(
                                    hintText: "Search...",
                                    obscureText: false,
                                    suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search,color: AppColors.textMuted,)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Get started with...",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
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