import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/serie_desktop.dart';
import 'package:xpvault/screens/mobile/home_mobile.dart';

class SeriesPage extends StatefulWidget {
  final Widget? returnPage;
  final String? username;

  const SeriesPage({super.key, this.returnPage, this.username});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: HomeMobilePage(),
        desktopBody: SerieDesktopPage(
          returnPage: widget.returnPage,
          username: widget.username,
        ),
      ),
    );
  }
}
