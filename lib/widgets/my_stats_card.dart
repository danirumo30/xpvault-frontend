import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyStatsCard extends StatelessWidget {
  final String title;
  final int value;
  final bool isTime;
  const MyStatsCard({super.key, required this.title, required this.value, required this.isTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTime ? "$value h" : "$value",
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}