import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/steam_desktop.dart';
import 'package:xpvault/screens/mobile/steam_mobile.dart';

class SteamPage extends StatefulWidget {
  final Widget? returnPage;
  final String? profileSteamId;

  const SteamPage({super.key, this.returnPage, this.profileSteamId});

  @override
  State<SteamPage> createState() => _SteamPageState();
}

class _SteamPageState extends State<SteamPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.profileSteamId);
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SteamMobilePage(returnPage: widget.returnPage),
        desktopBody: SteamDesktopPage(returnPage: widget.returnPage),
      ),
    );
  }
}
