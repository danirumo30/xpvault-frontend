import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyImageContainer extends StatefulWidget {
  final String title;
  final String body;
  final String image;
  final void Function()? onTap;

  const MyImageContainer({
    super.key,
    required this.title,
    required this.body,
    required this.image,
    this.onTap,
  });

  @override
  State<MyImageContainer> createState() => _MyImageContainerState();
}

class _MyImageContainerState extends State<MyImageContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.body,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
