import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "DISCOVER MOVIES",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading spinner while fetching movies
        if (movieController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        // Show message if no movies found
        if (movieController.movies.isEmpty) {
          return const Center(
            child: Text(
              "No movies available",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        // Show all movies in a grid
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: movieController.movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 movies per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // Make cards taller
          ),
          itemBuilder: (context, index) {
            final movie = movieController.movies[index];
            return _buildMovieCard(movie, movieController);
          },
        );
      }),
    );
  }

  // Simple movie card widget
  Widget _buildMovieCard(MovieModel movie, MovieController controller) {
    return GestureDetector(
      onTap: () {
        // Now gonna show  movie details when clicked
        Get.snackbar(
          movie.title,
          movie.description,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange, width: 2),
          image: movie.posterUrl.isNotEmpty 
            ? DecorationImage(
                image: NetworkImage(movie.posterUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), 
                  BlendMode.darken
                ),
              )
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (movie.posterUrl.isEmpty)
              const Icon(
                Icons.movie,
                color: Colors.orange,
                size: 60,
              ),
            const SizedBox(height: 10),
            
            // Movie title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                movie.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Rating with stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text(
                  movie.rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Year
            Text(
              movie.releaseDate,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(blurRadius: 10, color: Colors.black)],
              ),
            ),
            const SizedBox(height: 12),
            
            // Add to watchlist button
            Obx(() => GestureDetector(
              onTap: () => controller.toggleWatchlist(movie),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.isInWatchlist(movie) 
                      ? Colors.orange 
                      : Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(
                  controller.isInWatchlist(movie) ? "SAVED" : "SAVE",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}