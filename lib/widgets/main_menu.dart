import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/screens/playstation.dart';
import 'package:xpvault/screens/profile.dart';
import 'package:xpvault/screens/ranking.dart';
import 'package:xpvault/screens/steam.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: AppColors.primary),
          child: FutureBuilder<User?>(
            future: UserManager.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    const Text(
                      'Menú',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'User: ${user.username}',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                );
              } else {
                return const Text(
                  'Menú',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
                );
              }
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home, color: AppColors.textPrimary),
          title: const Text(
            "Home",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: AppColors.textPrimary),
          title: const Text(
            "Profile",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () async {
            final user = await UserManager.getUser();

            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(username: user.username),
                ),
              );
            } else {
              // Opcional: manejar el caso donde no hay usuario logueado
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No user is currently logged in")),
              );
            }
          },
        ),

        ListTile(
          leading: const Icon(
            Icons.movie_creation_outlined,
            color: AppColors.textPrimary,
          ),
          title: const Text(
            "Cinema",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MoviesSeriesPage(returnPage: MoviesSeriesPage(),)),
            );
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/steam-icon.svg',
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          title: const Text(
            "Steam",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SteamPage(returnPage: SteamPage(returnPage: SteamPage()))),
            );
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/playstation-icon.svg',
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          title: const Text(
            "Playstation",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PlaystationPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.emoji_events, color: AppColors.textPrimary),
          title: const Text(
            "Ranking",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RankingPage()),
            );
          },
        ),
      ],
    );
  }
}
