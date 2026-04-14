import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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

        if (movieController.movies.isEmpty) {
          return const Center(
            child: Text("No movies found", style: TextStyle(color: Colors.white)),
          );
        }

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
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.movie.sourceType == 'youtube') {
      _youtubeController = YoutubePlayerController(
        initialVideoId: widget.movie.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          hideControls: false,
          loop: true,
        ),
      );
    } else {
      // Clean path just in case
      String videoPath = widget.movie.videoId.trim();
      
      if (videoPath.contains('assets/')) {
        // Ensure path starts with 'assets/' and not '/assets/'
        if (videoPath.startsWith('/')) videoPath = videoPath.substring(1);
        _videoController = VideoPlayerController.asset(videoPath);
      } else {
        _videoController = VideoPlayerController.networkUrl(Uri.parse(videoPath));
      }

      _videoController?.initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoController?.play();
          _videoController?.setLooping(true);
        }
      }).catchError((error) {
        debugPrint("Video Player Error: $error");
        if (mounted) {
          setState(() => _isError = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Layer
        Positioned.fill(
          child: _isError 
            ? _buildErrorWidget()
            : widget.movie.sourceType == 'youtube'
              ? YoutubePlayer(controller: _youtubeController!)
              : (_videoController != null && _videoController!.value.isInitialized)
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  )
                : const Center(child: CircularProgressIndicator(color: Colors.orange)),
        ),

        // UI Overlay
        _buildContentOverlay(),
        _buildSideActions(),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.orange, size: 40),
            SizedBox(height: 10),
            Text("Video Unavailable", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentOverlay() {
    return Positioned(
      left: 20,
      bottom: 80, 
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.movie.title.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            widget.movie.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              const String netflixUrl = "https://www.netflix.com";
              final Uri url = Uri.parse(netflixUrl);
              try {
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              } catch (e) {
                debugPrint("Error opening Netflix: $e");
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text(
                    "WATCH NOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideActions() {
    return Positioned(
      right: 15,
      bottom: 120,
      child: Column(
        children: [
          _sideIconButton(Icons.local_fire_department, "85%", Colors.orange, "Hype"),
          const SizedBox(height: 25),
          _sideIconButton(Icons.rate_review_outlined, "Reviews", Colors.white, "Reviews"),
          const SizedBox(height: 25),
          _sideIconButton(Icons.add, "+ List", Colors.white, "Watchlist"),
          const SizedBox(height: 25),
          _sideIconButton(Icons.send_outlined, "Send", Colors.white, "Sharing"),
          const SizedBox(height: 25),
          _sideIconButton(Icons.info_outline, "Details", Colors.white, "Movie Details"),
        ],
      ),
    );
  }

  Widget _sideIconButton(IconData icon, String label, Color color, String featureName) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          "Coming Soon",
          "$featureName is being prepared for CINESCROLL.",
          backgroundColor: Colors.white,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 2),
        );
      },
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
