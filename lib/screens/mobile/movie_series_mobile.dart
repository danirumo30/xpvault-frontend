import 'package:flutter/material.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/screens/movie_detail.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/movie_grid_mobile.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/controllers/movie_controller.dart';

class MovieSeriesMobilePage extends StatefulWidget {
  final Widget? returnPage;
  final String? profileUsername;

  const MovieSeriesMobilePage({
    super.key,
    this.returnPage,
    this.profileUsername,
  });

  @override
  State<MovieSeriesMobilePage> createState() => _MovieSeriesMobilePageState();
}

class _MovieSeriesMobilePageState extends State<MovieSeriesMobilePage> {
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
    setState(() => _isLoadingMyMovies = true);
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
      loadedMovies = await movieController.getPopularMovies(page: _currentPage);
    }

    if (dropdownValue.isNotEmpty) {
      loadedMovies = loadedMovies
          .where((m) => m.genres.contains(dropdownValue))
          .toList();
    }

    setState(() {
      movies = loadedMovies;
      _isLoading = false;
    });
  }

  Future<void> _searchByGenre(String genre) async {
    setState(() => _isLoading = true);
    final loadedMovies = await movieController.getMoviesByGenre(
      genre,
      page: _currentPage,
    );

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
        builder: (_) => MovieDetailPage(
          movieId: movie.tmbdId,
          returnPage: widget.returnPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      title: "XPVAULT",
      body: RefreshIndicator(
        onRefresh: () async {
          await _initMovies();
          if (_profileUsername != null) {
            await _loadMyOwnedMovies(_profileUsername!);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // Search
            MyTextformfield(
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
            const SizedBox(height: 12),

            // Genre Dropdown
            MyDropdownbutton(
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
                DropdownMenuItem(value: "Science Fiction", child: Text("Sci-Fi")),
                DropdownMenuItem(value: "Thriller", child: Text("Thriller")),
                DropdownMenuItem(value: "TV Movie", child: Text("TV Movie")),
                DropdownMenuItem(value: "War", child: Text("War")),
                DropdownMenuItem(value: "Western", child: Text("Western")),
              ],
              onChanged: (value) {
                if (value is String) {
                  setState(() => _currentPage = 1);
                  _searchByGenre(value);
                }
              },
            ),

            const SizedBox(height: 16),
            Text("Movies", style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),),
            const SizedBox(height: 8),

            // Movie Grid
            MovieGridMobile(
              movies: movies,
              isLoading: _isLoading,
              onMovieTap: _showMovieDetails,
            ),

            const SizedBox(height: 16),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() => _currentPage--);
                          _loadMovies();
                        }
                      : null,
                  child: const Text("Previous"),
                ),
                Text("Page $_currentPage",style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _currentPage++);
                    _loadMovies();
                  },
                  child: const Text("Next"),
                ),
              ],
            ),

            const Divider(height: 32),

            // My Movies
            Text("My Movies", style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),),
            const SizedBox(height: 8),
            if (!_isUserLoggedIn)
              const Center(
                child: Text(
                  "Please log in to view your movies.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                ),
              )
            else if (_isLoadingMyMovies)
              const Center(child: CircularProgressIndicator())
            else if (myMovies.isEmpty)
              const Center(child: Text("You have no movies.", style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),))
            else
              Column(
                children: myMovies.map((movie) {
                  final imageUrl = (movie.posterUrl?.isNotEmpty ?? false)
                      ? movie.posterUrl!
                      : 'https://via.placeholder.com/150';

                  return GestureDetector(
                    onTap: () => _showMovieDetails(movie),
                    child: Card(
                      color: AppColors.secondary,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Image.network(imageUrl, width: 50, fit: BoxFit.cover),
                        title: Text(
                          movie.title,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            if (_isUserLoggedIn && _profileUsername != null)
              Center(
                child: ElevatedButton(
                  onPressed: () => _loadMyOwnedMovies(_profileUsername!),
                  child: const Text("Reload My Movies", style: TextStyle(color: AppColors.textPrimary),),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
