import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/steam_desktop.dart';
import 'package:xpvault/screens/mobile/steam_mobile.dart';

class SteamPage extends StatefulWidget {
  final Widget? returnPage;

  const SteamPage({super.key, this.returnPage});

  @override
  State<SteamPage> createState() => _SteamPageState();
}

class _SteamPageState extends State<SteamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SteamMobilePage(returnPage: widget.returnPage),
        desktopBody: SteamDesktopPage(returnPage: widget.returnPage),
      ),
    );
  }
}
