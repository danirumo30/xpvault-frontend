import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';

class MoviesSeriesPage extends StatefulWidget {
  const MoviesSeriesPage({super.key});

  @override
  State<MoviesSeriesPage> createState() => _MoviesSeriesPageState();
}

class _MoviesSeriesPageState extends State<MoviesSeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Scaffold(),
        desktopBody: Scaffold(),
      ),
    );
  }
}
