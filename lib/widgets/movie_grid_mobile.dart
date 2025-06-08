import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/models/movie.dart';

class MovieGridMobile extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  final void Function(Movie) onMovieTap;
  final Widget? returnPage;

  const MovieGridMobile({
    required this.movies,
    required this.isLoading,
    required this.onMovieTap,
    super.key,
    this.returnPage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (movies.isEmpty) {
      return const Center(child: Text("No movies found"));
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        final poster = movie.posterUrl ?? '';
        final year = movie.releaseDate.split('-').first;

        return _MovieCard(
          movie: movie,
          poster: poster,
          year: year,
          onTap: () => onMovieTap(movie),
        );
      },
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final String poster;
  final String year;
  final VoidCallback onTap;

  const _MovieCard({
    required this.movie,
    required this.poster,
    required this.year,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.background,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  poster,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                year,
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
