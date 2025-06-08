import 'package:flutter/material.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';

class MovieDetailMobilePage extends StatefulWidget {
  final int movieId;
  final Widget? returnPage;

  const MovieDetailMobilePage({
    super.key,
    required this.movieId,
    this.returnPage,
  });

  @override
  State<MovieDetailMobilePage> createState() => _MovieDetailMobilePageState();
}

class _MovieDetailMobilePageState extends State<MovieDetailMobilePage> {
  final MovieController _movieController = MovieController();
  final UserController _userController = UserController();

  Movie? _movie;
  bool _isLoading = true;
  bool _hoveringMovieTick = false;
  bool _hasMovie = false;

  @override
  void initState() {
    super.initState();
    _loadMovie();
  }

  Future<void> _loadMovie() async {
    final movie = await _movieController.getMovieById(widget.movieId);
    setState(() {
      _movie = movie;
      _isLoading = false;
    });
    final currentUser = await UserManager.getUser();
    if (currentUser != null && movie != null) {
      final hasMovie = await _userController.isMovieAdded(currentUser.username, movie.tmbdId);
      setState(() => _hasMovie = hasMovie);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MobileLayout(
        title: "XPVAULT",
        body: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_movie == null) {
      return MobileLayout(
        title: "XPVAULT",
        body: const Center(
          child: Text(
            "Movie not found",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ),
      );
    }

    final director = _movie!.director;

    return MobileLayout(
      title: 'XPVAULT',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.returnPage ?? const MoviesSeriesPage(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.accent),
              label: const Text('Back', style: TextStyle(color: AppColors.accent)),
            ),

            const SizedBox(height: 16),

            // Poster image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _movie!.posterUrl ?? '',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              _movie!.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Year and genres
            Text(
              "Year: ${_movie!.releaseDate.split('-').first}",
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              "Genres: ${_movie!.genres.join(', ')}",
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              _movie!.description.isNotEmpty
                  ? _movie!.description
                  : 'No description available',
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),

            const SizedBox(height: 24),

            // Cast
            _movie!.casting.isNotEmpty
                ? MyBuildContentBox(
                    items: _movie!.casting,
                    showBodyLabel: false,
                    title: "Cast",
                  )
                : const Text(
                    'Cast not found',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textMuted,
                    ),
                  ),

            const SizedBox(height: 24),

            // Director info
            Row(
              children: [
                if (director?.photoUrl != null &&
                    director!.photoUrl!.isNotEmpty &&
                    !director.photoUrl!.endsWith("null"))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      director.photoUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, color: AppColors.textMuted),
                    ),
                  )
                else
                  const Icon(Icons.person, size: 40, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    director?.name ?? "Director unknown",
                    style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Add/Delete movie button
            Center(
              child: GestureDetector(
                onTap: () async {
                  final currentUser = await UserManager.getUser();
                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login to add movies."),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                    return;
                  }

                  bool success;
                  if (_hasMovie) {
                    success = await _userController.deleteMovieFromUser(
                      currentUser.username,
                      _movie!.tmbdId,
                    );
                  } else {
                    success = await _userController.addMovieToUser(
                      currentUser.username,
                      _movie!.tmbdId,
                    );
                  }

                  if (success) {
                    setState(() => _hasMovie = !_hasMovie);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_hasMovie
                            ? "Movie added successfully!"
                            : "Movie deleted successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Something went wrong"),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                  }
                },
                child: AnimatedScale(
                  scale: _hoveringMovieTick ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveringMovieTick = true),
                    onExit: (_) => setState(() => _hoveringMovieTick = false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasMovie ? Colors.lightGreenAccent : Colors.grey,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
