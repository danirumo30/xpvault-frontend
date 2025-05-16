import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/playstation_desktop.dart';
import 'package:xpvault/screens/mobile/playstation_mobile.dart';

class PlaystationPage extends StatefulWidget {
  const PlaystationPage({super.key});

  @override
  State<PlaystationPage> createState() => _PlaystationPageState();
}

class _PlaystationPageState extends State<PlaystationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: PlaystationMobilePage(),
        desktopBody: PlaystationDesktop(),
      ),
    );
  }
}
