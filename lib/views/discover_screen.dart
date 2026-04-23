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
      body: Column(
        children: [
          // 1. Simple Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search movies...",
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.white24, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // 2. The Grid
          Expanded(
            child: Obx(() {
              if (movieController.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.orange));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: movieController.movies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = movieController.movies[index];
                  return _buildMovieCard(movie, movieController, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie, MovieController controller, int index) {
    return GestureDetector(
      onTap: () {
        // --- THIS IS THE NEW PART ---
        // 1. Set the movie index we want to see
        controller.selectedMovieIndex.value = index;
        // 2. Switch to the Home Feed tab (index 0)
        controller.currentTabIndex.value = 0;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: movie.posterUrl.isNotEmpty 
                ? Image.network(movie.posterUrl, fit: BoxFit.cover)
                : Container(color: Colors.white10),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 12),
                      const SizedBox(width: 4),
                      Text(movie.rating.toString(), style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      const Spacer(),
                      Obx(() => GestureDetector(
                        onTap: () => controller.toggleWatchlist(movie),
                        child: Icon(
                          controller.isInWatchlist(movie) ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.orange,
                          size: 22,
                        ),
                      )),
                    ],
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
