import 'package:flutter/material.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/themes/app_color.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: AppColors.primary
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              color: AppColors.textPrimary, 
              fontSize: 24
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home, 
            color: AppColors.textPrimary,
          ),
          title: const Text(
            "Home", 
            style: TextStyle(
              color: AppColors.textPrimary,
              )
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
          leading: const Icon(
            Icons.person,
            color: AppColors.textPrimary,
          ),
          title: const Text(
            "Profile",
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.group,
            color: AppColors.textPrimary,
          ),
          title: const Text(
            "Friends",
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.insert_chart_rounded,
            color: AppColors.textPrimary,
          ),
          title: const Text(
            "Ranking",
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.history,
            color: AppColors.textPrimary,
          ),
          title: const Text(
            "Last seen",
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}