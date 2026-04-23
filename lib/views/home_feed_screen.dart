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
    // Finding our movie controller
    final MovieController movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (movieController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (movieController.movies.isEmpty) {
          return const Center(
            child: Text("No movies found. Check your server!", 
              style: TextStyle(color: Colors.white)),
          );
        }

        debugPrint("Building Home Feed with ${movieController.movies.length} movies");

        return PageView.builder(
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
    
    // Simple logic: if it has http, it's from database/cloudinary. Else, it's local.
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
    }).catchError((error) {
       debugPrint("Video play error: $error");
    });
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
        // 1. THE VIDEO
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

        // 2. GRADIENT OVERLAY (to make text readable)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // 3. THE INFO AND BUTTONS
        Positioned(
          bottom: 15, // this si to ake it close to the bottom
          left: 15,
          right: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 22, // Even more compact
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 12),
              
              // ROW FOR BUTTONS
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showStreamingPicker(context, widget.movie.title),
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text("WATCH NOW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Obx(() => InkWell(
                    onTap: () => movieController.toggleWatchlist(widget.movie),
                    child: Row(
                      children: [
                        Icon(
                          movieController.isInWatchlist(widget.movie) 
                              ? Icons.check_circle 
                              : Icons.add_circle_outline,
                          color: Colors.orange,
                          size: 30,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          movieController.isInWatchlist(widget.movie) ? "SAVED" : "LIST",
                          style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 10),
              // Description at the absolute bottom
              Text(
                widget.movie.description,
                style: const TextStyle(
                  color: Colors.white60, 
                  fontSize: 10, // Very small for that TikTok look
                  height: 1.2,
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
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "WATCH '$title' ON:",
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _streamingTile(Icons.movie, "MovieBox Pro", "https://www.movieboxpro.app"),
              _streamingTile(Icons.play_circle_fill, "Netflix", "https://www.netflix.com"),
              _streamingTile(Icons.video_library, "Prime Video", "https://www.amazon.com"),
              _streamingTile(Icons.tv, "Disney+", "https://www.disneyplus.com"),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _streamingTile(IconData icon, String name, String url) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      onTap: () {
        Navigator.pop(context);
        _openLink(url);
      },
    );
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) debugPrint("Error opening $url");
  }
}
