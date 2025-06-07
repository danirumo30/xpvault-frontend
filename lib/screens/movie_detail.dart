import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/movie_detail_desktop.dart';
import 'package:xpvault/screens/mobile/home_mobile.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  final Widget? returnPage;

  const MovieDetailPage({super.key, required this.movieId, this.returnPage});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPage();
}

class _MovieDetailPage extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: HomeMobilePage(),
        desktopBody: MovieDetailDesktopPage(movieId: widget.movieId, returnPage: widget.returnPage,),
      ),
    );
  }
}