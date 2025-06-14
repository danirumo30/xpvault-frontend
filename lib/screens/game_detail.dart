import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/game_detail_desktop.dart';
import 'package:xpvault/screens/mobile/game_detail_mobile.dart';

class GameDetailPage extends StatefulWidget {
  final int steamId;
  final Widget? returnPage;

  const GameDetailPage({super.key, required this.steamId, this.returnPage});

  @override
  State<GameDetailPage> createState() => _GameDetailPage();
}

class _GameDetailPage extends State<GameDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: GameDetailMobilePage(steamId: widget.steamId,returnPage: widget.returnPage),
        desktopBody: GameDetailDesktopPage(steamId: widget.steamId,returnPage: widget.returnPage),
      ),
    );
  }
}
