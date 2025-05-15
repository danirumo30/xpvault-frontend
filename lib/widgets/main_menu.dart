import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/screens/playstation.dart';
import 'package:xpvault/screens/steam.dart';
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
          child: const Text(
            'Menu',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
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
          onTap: () {
            Navigator.pop(context);
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MoviesSeriesPage()));
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/steam-icon.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
          ),
          title: const Text(
            "Steam",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SteamPage()));
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/playstation-icon.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
          ),
          title: const Text(
            "Playstation",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlaystationPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.history, color: AppColors.textPrimary),
          title: const Text(
            "Last seen",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
