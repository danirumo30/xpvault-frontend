import 'package:flutter/material.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/widgets/cast_with_navigation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/layouts/desktop_layout.dart';

class MovieDetailDesktopPage extends StatefulWidget {
  final int movieId;

  const MovieDetailDesktopPage({super.key, required this.movieId});

  @override
  State<MovieDetailDesktopPage> createState() => _MovieDetailDesktopPageState();
}

class _MovieDetailDesktopPageState extends State<MovieDetailDesktopPage> {
  final MovieController _movieController = MovieController();

  Movie? _movie;
  bool _isLoading = true;

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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_movie == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Movie not found",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ),
      );
    }

    final director = _movie!.director;

    return DesktopLayout(
      title: 'XPVAULT',
      body: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                    label: const Text(
                      'Back',
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _movie!.title,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Year: ${_movie!.releaseDate.split('-').first}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Genres: ${_movie!.genres.join(', ')}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _movie!.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                "Cast:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CastWithNavigation(casting: _movie!.casting),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Right side
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _movie!.posterUrl ?? '',
                                  height: 350,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 100, color: AppColors.error),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      const Icon(Icons.person,
                                          color: AppColors.textMuted),
                                    ),
                                  )
                                else
                                  const Icon(Icons.person,
                                      size: 40, color: AppColors.textMuted),
                                const SizedBox(width: 8),
                                Text(
                                  director?.name ?? "Director desconocido",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
