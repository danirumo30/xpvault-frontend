import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/services/user_manager.dart';
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
  final String? profileUsername;

  const MoviesSeriesDesktop({super.key, this.returnPage, this.profileUsername});

  @override
  State<MoviesSeriesDesktop> createState() => _MoviesSeriesDesktopState();
}

class _MoviesSeriesDesktopState extends State<MoviesSeriesDesktop> {
  String? _profileUsername;
  String? _loggedInUsername;
  List<Movie> movies = [];
  List<Movie> myMovies = [];
  bool _isLoading = true;
  bool _isLoadingMyMovies = false;
  bool _isUserLoggedIn = false;

  final TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  String dropdownValue = "";

  final MovieController movieController = MovieController();

  @override
  void initState() {
    super.initState();
    _initUserContext();
    _initMovies();
  }

  Future<void> _initUserContext() async {
    final currentUser = await UserManager.getUser();
    setState(() {
      _isUserLoggedIn = currentUser != null;
      _loggedInUsername = currentUser?.username;
      // Si profileUsername está definido en el widget, usarlo, si no, usar el username logueado (puede ser null)
      _profileUsername = widget.profileUsername ?? _loggedInUsername;
    });
    if (_profileUsername != null) {
      await _loadMyOwnedMovies(_profileUsername!);
    }
  }

  Future<void> _initMovies() async {
    await movieController.loadMoviesFromAssets('movies.json');
    await _loadMovies();
  }

  Future<void> _loadMyOwnedMovies(String username) async {
    setState(() {
      _isLoadingMyMovies = true;
    });

    final loadedMovies = await movieController.fetchUserMovies(username);

    setState(() {
      myMovies = loadedMovies;
      _isLoadingMyMovies = false;
    });
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

  Future<void> _searchByGenre(String genre) async {
    setState(() => _isLoading = true);
    List<Movie> loadedMovies = await movieController.getMoviesByGenre(genre, page: _currentPage);

    setState(() {
      movies = loadedMovies;
      dropdownValue = genre;
      searchController.clear();
      _isLoading = false;
    });
  }

  void _showMovieDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailDesktopPage(movieId: movie.tmbdId, returnPage: widget.returnPage),
      ),
    );
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
                      DropdownMenuItem(value: "Action", child: Text("Action")),
                      DropdownMenuItem(value: "Adventure", child: Text("Adventure")),
                      DropdownMenuItem(value: "Animation", child: Text("Animation")),
                      DropdownMenuItem(value: "Comedy", child: Text("Comedy")),
                      DropdownMenuItem(value: "Crime", child: Text("Crime")),
                      DropdownMenuItem(value: "Documentary", child: Text("Documentary")),
                      DropdownMenuItem(value: "Drama", child: Text("Drama")),
                      DropdownMenuItem(value: "Family", child: Text("Family")),
                      DropdownMenuItem(value: "Horror", child: Text("Horror")),
                      DropdownMenuItem(value: "Music", child: Text("Music")),
                      DropdownMenuItem(value: "Mystery", child: Text("Mystery")),
                      DropdownMenuItem(value: "Romance", child: Text("Romance")),
                      DropdownMenuItem(value: "Science Fiction", child: Text("Science Fiction")),
                      DropdownMenuItem(value: "Thriller", child: Text("Thriller")),
                      DropdownMenuItem(value: "TV Movie", child: Text("TV Movie")),
                      DropdownMenuItem(value: "War", child: Text("War")),
                      DropdownMenuItem(value: "Western", child: Text("Western")),
                    ],
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          _currentPage = 1;
                        });
                        _searchByGenre(value);
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
                  // Movies (public)
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
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: _currentPage > 1
                                      ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                    _loadMovies();
                                  }
                                      : null,
                                  child: const Text("Previous"),
                                ),
                                Text(
                                  'Page $_currentPage',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                    _loadMovies();
                                  },
                                  child: const Text("Next"),
                                ),
                              ],
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
                              _profileUsername == null
                                  ? "My Movies"
                                  : "${_profileUsername!} Movies",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _profileUsername == null
                                  ? Center(
                                child: Text(
                                  "Please log in to view your movies.",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  : _isLoadingMyMovies
                                  ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                ),
                              )
                                  : myMovies.isEmpty
                                  ? Center(
                                child: Text(
                                  "No movies found.",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  : GridView.builder(
                                itemCount: myMovies.length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 5,
                                ),
                                itemBuilder: (context, index) {
                                  final movie = myMovies[index];
                                  final imageUrl = (movie.posterUrl?.trim().isNotEmpty ?? false)
                                      ? movie.posterUrl!
                                      : 'https://via.placeholder.com/150';

                                  bool isHovered = false;

                                  return StatefulBuilder(
                                    builder: (context, setStateHover) {
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onEnter: (_) => setStateHover(() => isHovered = true),
                                        onExit: (_) => setStateHover(() => isHovered = false),
                                        child: AnimatedScale(
                                          scale: isHovered ? 1.05 : 1.0,
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          child: GestureDetector(
                                            onTap: () => _showMovieDetails(movie),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.secondary,
                                                borderRadius: BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                    Colors.black.withOpacity(0.4),
                                                    BlendMode.darken,
                                                  ),
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(12),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                movie.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_profileUsername != null)
                              ElevatedButton(
                                onPressed: () => _loadMyOwnedMovies(_profileUsername!),
                                child: const Text("Reload Movies"),
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
