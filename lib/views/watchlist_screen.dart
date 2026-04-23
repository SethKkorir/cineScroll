import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (movieController.watchlist.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, color: Colors.white.withOpacity(0.05), size: 80),
                const SizedBox(height: 20),
                Text(
                  "YOUR WATCHLIST IS EMPTY",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.2),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Save trailers to watch them later.",
                  style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: movieController.watchlist.length,
          itemBuilder: (context, index) {
            final movie = movieController.watchlist[index];
            return _buildWatchlistItem(movie, movieController);
          },
        );
      }),
    );
  }

  Widget _buildWatchlistItem(MovieModel movie, MovieController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 60,
            height: 90,
            child: movie.posterUrl.isNotEmpty 
              ? Image.network(movie.posterUrl, fit: BoxFit.cover)
              : Container(color: Colors.white10, child: const Icon(Icons.movie, color: Colors.orange)),
          ),
        ),
        title: Text(
          movie.title.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 12),
                const SizedBox(width: 4),
                Text(movie.rating.toString(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(width: 10),
                Text(movie.releaseDate, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.white24, size: 20),
          onPressed: () => controller.toggleWatchlist(movie),
        ),
        onTap: () {
          Get.snackbar(movie.title, "Playing trailer...", 
            backgroundColor: Colors.orange, colorText: Colors.black, snackPosition: SnackPosition.BOTTOM);
        },
      ),
    );
  }
}
