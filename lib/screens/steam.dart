import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/steam_desktop.dart';

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
        mobileBody: Scaffold(),
        desktopBody: SteamDesktopPage(returnPage: widget.returnPage),
      ),
    );
  }
}
