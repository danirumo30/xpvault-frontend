import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/steam_desktop.dart';

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
        mobileBody: Scaffold(),
        desktopBody: SteamDesktopPage(returnPage: widget.returnPage, profileSteamId: widget.profileSteamId),
      ),
    );
  }
}
