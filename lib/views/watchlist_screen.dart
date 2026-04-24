import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (movieController.watchlist.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bookmark_add_outlined, color: Colors.black12, size: 100),
                const SizedBox(height: 20),
                const Text(
                  "YOUR LIST IS EMPTY", 
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)
                ),
                const Text(
                  "Trailers you save will appear here.", 
                  style: TextStyle(color: Colors.black54, fontSize: 14)
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: movieController.watchlist.length,
          itemBuilder: (context, index) => _item(movieController.watchlist[index], movieController),
        );
      }),
    );
  }

  // Simplified Item Widget
  Widget _item(MovieModel movie, MovieController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        dense: true, // Makes it more compact
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: movie.posterUrl.isNotEmpty 
            ? Image.network(movie.posterUrl, width: 45, height: 65, fit: BoxFit.cover)
            : Container(width: 45, height: 65, color: Colors.grey[200], child: const Icon(Icons.movie, size: 16, color: Colors.grey)),
        ),
        title: Text(
          movie.title.toUpperCase(), 
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, 
            fontSize: 12, 
            letterSpacing: 0.3
          )
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 12),
            const SizedBox(width: 4),
            Text(
              movie.rating.toString(), 
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold, 
                fontSize: 10
              )
            ),
            const SizedBox(width: 8),
            Text(
              movie.releaseDate,
              style: const TextStyle(color: Colors.black38, fontSize: 10)
            ),
          ],
        ),
        trailing: IconButton(
          constraints: const BoxConstraints(), // Removes extra padding
          padding: EdgeInsets.zero,
          onPressed: () => controller.toggleWatchlist(movie),
          icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
        ),
      ),
    );
  }
}
