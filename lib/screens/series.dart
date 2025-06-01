import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/serie_desktop.dart';

class SeriesPage extends StatefulWidget {
  final Widget? returnPage;

  const SeriesPage({super.key, this.returnPage});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Scaffold(),
        desktopBody: SerieDesktopPage(returnPage: widget.returnPage),
      ),
    );
  }
}
