import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyBuildSectionTitle extends StatelessWidget {
  final String title;

  const MyBuildSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}