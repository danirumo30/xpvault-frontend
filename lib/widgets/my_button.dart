import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final void Function()? onTap;

  const MyButton({super.key, required this.text, this.onTap, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: fontSize
              ),
            ),
          ),
        ),
      ),
    );
  }
}