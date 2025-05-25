import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyBuildContentBox extends StatelessWidget {
  const MyBuildContentBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Contenido próximamente...",
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}