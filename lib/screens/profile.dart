import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/profile_desktop.dart';
import 'package:xpvault/screens/mobile/profile_mobile.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String? steamId;

  const ProfilePage({super.key, required this.username, this.steamId});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: ProfileMobilePage(username: widget.username, steamId: widget.steamId),
      desktopBody: ProfileDesktopPage(username: widget.username, steamId: widget.steamId),
    );
  }
}
