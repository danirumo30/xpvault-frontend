import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/game_detail_desktop.dart';
import 'package:xpvault/screens/mobile/home_mobile.dart';

class GameDetailPage extends StatefulWidget {
  final int steamId;
  const GameDetailPage({super.key, required this.steamId});

  @override
  State<GameDetailPage> createState() => _GameDetailPage();
}

class _GameDetailPage extends State<GameDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: HomeMobilePage(),
        desktopBody: GameDetailDesktopPage(steamId: widget.steamId,),
      ),
    );
  }
}
