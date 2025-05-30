import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/ranking_desktop.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Scaffold(),
        desktopBody: const RankingDesktopPage(),
      ),
    );
  }
}
