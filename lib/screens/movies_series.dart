import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/movies_series_desktop.dart';
import 'package:xpvault/screens/mobile/movie_series_mobile.dart';

class MoviesSeriesPage extends StatefulWidget {
  final Widget? returnPage;
  final String? profileUsername;

  const MoviesSeriesPage({super.key, this.returnPage, this.profileUsername});

  @override
  State<MoviesSeriesPage> createState() => _MoviesSeriesPageState();
}

class _MoviesSeriesPageState extends State<MoviesSeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MovieSeriesMobilePage(returnPage: widget.returnPage,
          profileUsername: widget.profileUsername,),
        desktopBody: MoviesSeriesDesktop(
          returnPage: widget.returnPage,
          profileUsername: widget.profileUsername,
        ),
      ),
    );
  }
}

