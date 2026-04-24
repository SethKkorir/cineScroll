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
      backgroundColor: Colors.transparent, // Let gradient show
      body: Column(
        children: [
          // 1. Floating Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: const TextField(
                style: TextStyle(color: Colors.black), // Search text black
                decoration: InputDecoration(
                  hintText: "Search trailers...",
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 15), // Hint dark grey
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.orange, size: 24),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
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
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                itemCount: movieController.movies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.7,
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
        controller.selectedMovieIndex.value = index;
        controller.currentTabIndex.value = 0;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Positioned.fill(
                child: movie.posterUrl.isNotEmpty 
                  ? Image.network(movie.posterUrl, fit: BoxFit.cover)
                  : Container(color: Colors.grey[200]),
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(movie.rating.toString(), style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Obx(() => Icon(
                          controller.isInWatchlist(movie) ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.orange,
                          size: 20,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
