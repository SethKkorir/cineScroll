import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("MY WATCHLIST", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (movieController.watchlist.isEmpty) {
          return const Center(
            child: Text("Your watchlist is empty", style: TextStyle(color: Colors.white54)),
          );
        }

        return ListView.builder(
          itemCount: movieController.watchlist.length,
          itemBuilder: (context, index) {
            final movie = movieController.watchlist[index];
            return ListTile(
              leading: movie.posterUrl.isNotEmpty 
                ? Image.network(movie.posterUrl, width: 50, fit: BoxFit.cover)
                : const Icon(Icons.movie, color: Colors.orange),
              title: Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(movie.releaseDate, style: const TextStyle(color: Colors.white54)),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => movieController.toggleWatchlist(movie),
              ),
            );
          },
        );
      }),
    );
  }
}
