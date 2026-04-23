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
    debugPrint("=== Initializing Player ===");
    debugPrint("Movie: ${widget.movie.title}");
    debugPrint("Source Type: ${widget.movie.sourceType}");
    debugPrint("Video ID/URL: ${widget.movie.VideoUrl}");

    if (widget.movie.sourceType == 'youtube') {
      // YouTube videos
      _youtubeController = YoutubePlayerController(
        initialVideoId: widget.movie.VideoUrl,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          hideControls: false,
          loop: true,
        ),
      );
    } else if (widget.movie.sourceType == 'local') {
      // Local asset videos
      String videoPath = widget.movie.VideoUrl.trim();
      

      if (videoPath.startsWith('/')) {
        videoPath = videoPath.substring(1);
      }
      
      debugPrint("Loading local asset: $videoPath");
      _videoController = VideoPlayerController.asset(videoPath);
      _initializeVideoController();
      
    } else if (widget.movie.sourceType == 'cloudinary') {
      // Cloudinary network videos (from database)
      debugPrint("Loading Cloudinary video: ${widget.movie.VideoUrl}");
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.movie.VideoUrl),
      );
      _initializeVideoController();
      
    } else {
      // Fallback: try to detect if it's a URL or asset path
      String videoPath = widget.movie.VideoUrl.trim();
      
      if (videoPath.startsWith('http://') || videoPath.startsWith('https://')) {
        // Network URL
        debugPrint("Loading network video: $videoPath");
        _videoController = VideoPlayerController.networkUrl(Uri.parse(videoPath));
      } else {
        // Asset path
        if (videoPath.startsWith('/')) videoPath = videoPath.substring(1);
        debugPrint("Loading asset: $videoPath");
        _videoController = VideoPlayerController.asset(videoPath);
      }
      _initializeVideoController();
    }
  }

  void _initializeVideoController() {
    _videoController?.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _videoController?.play();
        _videoController?.setLooping(true);
        debugPrint("✅ Video initialized successfully");
      }
    }).catchError((error) {
      debugPrint("❌ Video Player Error: $error");
      if (mounted) {
        setState(() => _isError = true);
      }
    });
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

        // Tap to play/pause (for non-YouTube videos)
        if (widget.movie.sourceType != 'youtube' && 
            _videoController != null && 
            _videoController!.value.isInitialized)
          GestureDetector(
            onTap: () {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              });
            },
            child: Container(color: Colors.transparent),
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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 40),
            const SizedBox(height: 10),
            const Text(
              "Video Unavailable", 
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.title,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
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
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 24, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 1.2,
              shadows: [
                Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.movie.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70, 
              fontSize: 13, 
              height: 1.4,
              shadows: [
                Shadow(blurRadius: 8, color: Colors.black, offset: Offset(1, 1)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Rating and Year
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.movie.rating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.movie.releaseDate,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
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
    final MovieController movieController = Get.find<MovieController>();
    return Positioned(
      right: 15,
      bottom: 100,
      child: Column(
        children: [
          _sideIconButton(Icons.local_fire_department, "85%", Colors.orange, "Hype"),
          const SizedBox(height: 25),
          _sideIconButton(Icons.rate_review_outlined, "Reviews", Colors.white, "Reviews"),
          const SizedBox(height: 25),
          Obx(() => _sideIconButton(
            movieController.isInWatchlist(widget.movie) ? Icons.check_circle : Icons.add, 
            movieController.isInWatchlist(widget.movie) ? "Saved" : "+ List", 
            movieController.isInWatchlist(widget.movie) ? Colors.orange : Colors.white, 
            "Watchlist",
            onTap: () => movieController.toggleWatchlist(widget.movie),
          )),
          const SizedBox(height: 25),
          _sideIconButton(Icons.send_outlined, "Send", Colors.white, "Sharing"),
          const SizedBox(height: 25),
          _sideIconButton(Icons.info_outline, "Details", Colors.white, "Movie Details"),
        ],
      ),
    );
  }

  Widget _sideIconButton(IconData icon, String label, Color color, String featureName, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        Get.snackbar(
          "Coming Soon",
          "$featureName is being prepared.",
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
          Text(
            label, 
            style: TextStyle(
              color: color, 
              fontSize: 10, 
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(blurRadius: 4, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}