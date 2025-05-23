import 'package:flutter/material.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/themes/app_color.dart';

class PlaystationMobilePage extends StatefulWidget {
  const PlaystationMobilePage({super.key});

  @override
  State<PlaystationMobilePage> createState() => _PlaystationMobilePageState();
}

class _PlaystationMobilePageState extends State<PlaystationMobilePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      title: "XPVAULT",
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.construction,
                  size: 100,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'This page will be available in future updates.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Thanks for your patience!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}