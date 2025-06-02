import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyStatsCard extends StatelessWidget {
  final String title;
  final int value; // value en minutos
  final bool isTime;
  const MyStatsCard({super.key, required this.title, required this.value, required this.isTime});

  String _formatMinutesToHoursMinutes(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return "$hours h ${remainingMinutes} m";
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = isTime ? _formatMinutesToHoursMinutes(value) : value.toString();

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
            displayValue,
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
