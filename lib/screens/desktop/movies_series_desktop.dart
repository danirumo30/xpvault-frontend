import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/widgets/movie_grid.dart';
import 'package:xpvault/screens/desktop/movie_detail_desktop.dart';
import 'dart:async';

class MoviesSeriesDesktop extends StatefulWidget {
  final Widget? returnPage;

  const MoviesSeriesDesktop({super.key, this.returnPage});

  @override
  State<MoviesSeriesDesktop> createState() => _MoviesSeriesDesktopState();
}

class _MoviesSeriesDesktopState extends State<MoviesSeriesDesktop> {
  List<Movie> movies = [];
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  String dropdownValue = "";

  void _showMovieDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailDesktopPage(movieId: movie.tmbdId, returnPage: widget.returnPage,),
      ),
    );
  }

  final MovieController movieController = MovieController();

  Future<void> _initMovies() async {
    await movieController.loadMoviesFromAssets('movies.json');
    await _loadMovies();
  }

  @override
  void initState() {
    super.initState();
    _initMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);

    List<Movie> loadedMovies;
    if (searchController.text.trim().isNotEmpty) {
      loadedMovies = await movieController.searchMovieByTitle(
        searchController.text.trim(),
        page: _currentPage,
      );
    } else {
      loadedMovies = await movieController.getPopularMovies(
        page: _currentPage,
      );
    }

    if (dropdownValue.isNotEmpty) {
      loadedMovies =
          loadedMovies.where((m) => m.genres.contains(dropdownValue)).toList();
    }

    setState(() {
      movies = loadedMovies;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: MyTextformfield(
                    textEditingController: searchController,
                    hintText: "Search",
                    obscureText: false,
                    suffixIcon: Icon(Icons.search, color: AppColors.textMuted),
                    onFieldSubmitted: (value) {
                      setState(() {
                        _currentPage = 1;
                      });
                      _loadMovies();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: MyDropdownbutton(
                    hint: dropdownValue.isEmpty ? "Select genre" : dropdownValue,
                    items: const [
                      DropdownMenuItem(
                        value: "Action",
                        child: Text("Action"),
                      ),
                      DropdownMenuItem(
                        value: "Horror",
                        child: Text("Horror"),
                      ),
                      DropdownMenuItem(
                        value: "Adventure",
                        child: Text("Adventure"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          dropdownValue = value;
                          _currentPage = 1;
                        });
                        _loadMovies();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Movies",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: MovieGrid(
                                movies: movies,
                                isLoading: _isLoading,
                                onMovieTap: _showMovieDetails,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last seen",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: const Center(
                                child: Text("No movie selected"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
