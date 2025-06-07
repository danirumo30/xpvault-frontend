import 'package:flutter/material.dart';
import 'package:xpvault/controllers/movie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/models/movie.dart';
import 'package:xpvault/screens/movies_series.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/widgets/cast_with_navigation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';

class MovieDetailDesktopPage extends StatefulWidget {
  final int movieId;
  final Widget? returnPage;

  const MovieDetailDesktopPage({
    super.key,
    required this.movieId,
    this.returnPage,
  });

  @override
  State<MovieDetailDesktopPage> createState() => _MovieDetailDesktopPageState();
}

class _MovieDetailDesktopPageState extends State<MovieDetailDesktopPage> {
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
    if (currentUser != null) {
      final hasMovie = await _userController.isMovieAdded(currentUser.username, movie!.tmbdId);
      setState(() {
        _hasMovie = hasMovie;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return DesktopLayout(
        title: "XPVAULT",
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_movie == null) {
      return DesktopLayout(
        title: "XPVAULT",
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
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (widget.returnPage != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.returnPage!,
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviesSeriesPage(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                      label: const Text(
                        'Back',
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _hoveringMovieTick = true),
                      onExit: (_) => setState(() => _hoveringMovieTick = false),
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
                            success = await _userController.deleteMovieFromUser(currentUser.username, _movie!.tmbdId);
                          } else {
                            success = await _userController.addMovieToUser(currentUser.username, _movie!.tmbdId);
                          }

                          if (success) {
                            setState(() {
                              _hasMovie = !_hasMovie;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_hasMovie ? "Movie added successfully!" : "Movie deleted successfully!"),
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
                          scale: _hoveringMovieTick ? 1.3 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _hasMovie ? Colors.lightGreenAccent : Colors.grey,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                                (_movie!.description.isNotEmpty)
                                    ? _movie!.description
                                    : 'No description available',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _movie!.casting.isNotEmpty
                                  ? SizedBox(
                                child: MyBuildContentBox(
                                  items: _movie!.casting,
                                  showBodyLabel: false,
                                  title: "Cast",
                                ),
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
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Right side
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
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
                                      const Icon(Icons.broken_image, size: 100, color: AppColors.error),
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
        ),
      ),
    );
  }
}
