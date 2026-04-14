import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.put(MovieController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (movieController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        return Stack(
          children: [
            // Vertical Video Feed
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: movieController.movies.length,
              itemBuilder: (context, index) {
                return ReelTile(movie: movieController.movies[index]);
              },
            ),
            
            // Top Navigation Overlay
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopTab("For You", true),
                  const SizedBox(width: 20),
                  _buildTopTab("Following", false),
                ],
              ),
            ),
            
            // Search Icon
            Positioned(
              top: 45,
              right: 20,
              child: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.8), size: 28),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTopTab(String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 20,
            color: Colors.orange, // Changed from Teal to Orange
          ),
      ],
    );
  }
}

class ReelTile extends StatefulWidget {
  final MovieModel movie;
  const ReelTile({super.key, required this.movie});

  @override
  State<ReelTile> createState() => _ReelTileState();
}

class _ReelTileState extends State<ReelTile> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.movie.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full Screen Video
        Positioned.fill(
          child: _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Container(color: Colors.black),
        ),

        // Gradient Overlays for Readability
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.2, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // Right Sidebar Actions (Premium Style)
        Positioned(
          right: 15,
          bottom: 120,
          child: Column(
            children: [
              _buildSideAction(Icons.favorite_border, "24k"),
              const SizedBox(height: 25),
              _buildSideAction(Icons.bookmark_border, "Save"),
              const SizedBox(height: 25),
              _buildSideAction(Icons.share_outlined, "Share"),
              const SizedBox(height: 25),
              _buildSideAction(Icons.info_outline, "Info"),
            ],
          ),
        ),

        // Bottom Content (Netflix Hero Style)
        Positioned(
          left: 20,
          bottom: 40,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Title
              Text(
                widget.movie.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              // Description
              Text(
                widget.movie.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              // Watch Now Button
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange, // Changed from Teal to Orange
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "WATCH NOW",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
