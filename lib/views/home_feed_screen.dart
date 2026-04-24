import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.transparent, // Let gradient show
      body: Obx(() {
        if (movieController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (movieController.movies.isEmpty) {
          return const Center(
            child: Text("No trailers found.", style: TextStyle(color: Colors.black45)),
          );
        }

        return PageView.builder(
          key: ValueKey(movieController.selectedMovieIndex.value), 
          controller: PageController(initialPage: movieController.selectedMovieIndex.value),
          scrollDirection: Axis.vertical,
          itemCount: movieController.movies.length,
          itemBuilder: (context, index) {
            return ReelTile(movie: movieController.movies[index]);
          },
        );
      }),
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
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupVideo();
  }

  void _setupVideo() {
    String path = widget.movie.videoUrl;
    if (path.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(path));
    } else {
      _controller = VideoPlayerController.asset(path);
    }

    _controller?.initialize().then((_) {
      if (mounted) {
        setState(() => _isInitialized = true);
        _controller?.play();
        _controller?.setLooping(true);
      }
    }).catchError((error) => debugPrint("Video error: $error"));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return Stack(
      children: [
        // VIDEO BACKGROUND
        Positioned.fill(
          child: _isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : const Center(child: CircularProgressIndicator(color: Colors.orange)),
        ),
        
        // SOFT GRADIENT OVERLAY
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // CONTENT
        Positioned(
          bottom: 20, // Slightly moved up
          left: 15,
          right: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 16, // Reduced from 18
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              Row(
                children: [
                  // FLOATING ORANGE BUTTON
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _showStreamingPicker(context, widget.movie.title),
                      icon: const Icon(Icons.play_arrow_rounded, size: 14),
                      label: const Text("WATCH NOW", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 8, letterSpacing: 0.5)), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // More compact
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  
                  // SAVE BUTTON
                  Obx(() => InkWell(
                    onTap: () => movieController.toggleWatchlist(widget.movie),
                    child: Column(
                      children: [
                        Icon(
                          movieController.isInWatchlist(widget.movie) 
                              ? Icons.bookmark_added_rounded 
                              : Icons.bookmark_add_outlined,
                          color: Colors.orange,
                          size: 18, // Reduced from 22
                        ),
                        const SizedBox(height: 2),
                        Text(
                          movieController.isInWatchlist(widget.movie) ? "SAVED" : "LIST",
                          style: const TextStyle(color: Colors.orange, fontSize: 7, fontWeight: FontWeight.bold), // Reduced from 8
                        )
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 10), // Reduced spacing
              Text(
                widget.movie.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10, // Reduced from 12
                  height: 1.3,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showStreamingPicker(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "WATCH '$title'".toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
              ),
              const SizedBox(height: 10),
              const Text("Select a streaming platform", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 30),
              _streamingTile(Icons.play_circle_fill, "Netflix", "https://www.netflix.com"),
              _streamingTile(Icons.video_library, "Prime Video", "https://www.amazon.com"),
              _streamingTile(Icons.tv, "Disney+", "https://www.disneyplus.com"),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _streamingTile(IconData icon, String name, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(name, style: const TextStyle(color: Color(0xFF2D3436), fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 14),
        onTap: () {
          Navigator.pop(context);
          _openLink(url);
        },
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) debugPrint("Error opening $url");
  }
}
