import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.put(MovieController());

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("FOR YOU", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
            SizedBox(width: 20),
            Text("FOLLOWING", style: TextStyle(color: Color.fromRGBO(255,255,255,0.5), fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white)),
        ],
      ),
      body: Obx(() {
        if (movieController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: movieController.movies.length,
          itemBuilder: (context, index) {
            final movie = movieController.movies[index];

            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // 1. FULL SCREEN BACKGROUND (Poster now, Video later)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(movie.posterUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 2. DARK GRADIENT OVERLAY (For text readability)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),

                // Right-side social/action area temporarily removed

                // 4. BOTTOM INFO SECTION
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 40, right: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie Title
                      Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1),
                      ),
                      const SizedBox(height: 10),
                      // Tags (Scifi, Action, Rating)
                      Row(
                        children: [
                          _buildTag("#SCIFI"),
                          const SizedBox(width: 8),
                          _buildTag("#ACTION"),
                          const SizedBox(width: 15),
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                          const Text(" 95%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Quote/Description
                      Text(
                        "\"${movie.description}\"",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

                // 5. STREAMING PILL (Floating Cyan Button)
                Positioned(
                  right: 20,
                  bottom: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: const Row(
                      children: [
                        Text("STREAMING\nON: HBO MAX", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                        SizedBox(width: 10),
                        Icon(Icons.share, color: Colors.black, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  // Helper for Side Icons
  // Helper for Tags
  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255,255,255,0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color.fromRGBO(255,255,255,0.2)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}