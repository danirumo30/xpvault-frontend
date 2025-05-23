import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class RedirectMessage extends StatelessWidget {
  final String mainText;
  final String linkText;
  final void Function()? onTap;

  const RedirectMessage({
    super.key,
    required this.mainText,
    required this.linkText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            mainText,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                linkText,
                style: TextStyle(
                  color: AppColors.accent,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
