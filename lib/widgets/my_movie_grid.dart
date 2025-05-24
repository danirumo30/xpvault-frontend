import 'package:flutter/material.dart';

class MyMovieGrid extends StatelessWidget {
  final List<Map<String, dynamic>> movies;
  final void Function(String imdbID)? onMovieTap;

  const MyMovieGrid({super.key, required this.movies, this.onMovieTap});

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(child: Text("No movies found"));
    }

    return GridView.builder(
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2 / 3, // Altura relativa
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        final title = movie["Title"] ?? "No title";
        final year = movie["Year"] ?? "";
        final type = movie["Type"] ?? "";
        final posterUrl = movie["Poster"] ?? "";
        final imdbID = movie["imdbID"];

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
              maxHeight: 450,
            ),
            child: GestureDetector(
              onTap: () {
                if (onMovieTap != null && imdbID != null) {
                  onMovieTap!(imdbID);
                }
              },
              child: Card(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        posterUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0), // 🔽 Menos padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16, // 🔽 Más pequeño
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4), // 🔽 Menos espacio
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                capitalize(type),
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                year,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
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
      },
    );
  }
}
