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

        // --- THIS IS THE MAGIC PART ---
        // We use a PageController with the selected movie as the starting page.
        // The ValueKey ensures that if we pick a different movie in Discover, 
        // the Home Feed resets and jumps to that movie.
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
        Positioned(
          bottom: 15,
          left: 15,
          right: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showStreamingPicker(context, widget.movie.title),
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text("WATCH NOW", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
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
              Text(
                widget.movie.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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
      backgroundColor: const Color(0xFF0F0F0F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "WATCH '$title' ON:".toUpperCase(),
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1),
              ),
              const SizedBox(height: 25),
              _streamingTile(Icons.movie, "MovieBox Pro", "https://www.movieboxpro.app"),
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
