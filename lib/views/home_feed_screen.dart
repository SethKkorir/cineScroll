import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.put(MovieController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // Show loading spinner while fetching
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF05FFD1)),
          );
        }

        // Show message if there are no movies
        if (controller.movies.isEmpty) {
          return const Center(
            child: Text(
              'No movies found.\nMake sure the server is running.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          );
        }

        // TikTok-style vertical scrollable feed
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: controller.movies[index]);
          },
        );
      }),
    );
  }
}

// ─── Single Movie Card ─────────────────────────────────────────────────────────

class MovieCard extends StatefulWidget {
  final MovieModel movie;
  const MovieCard({super.key, required this.movie});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background poster image ──────────────────────────────────────────
        _PosterBackground(url: widget.movie.posterUrl),

        // ── Dark gradient overlay (bottom heavy) ─────────────────────────────
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black87,
                Colors.black,
              ],
              stops: [0.0, 0.4, 0.75, 1.0],
            ),
          ),
        ),

        // ── Top bar: logo + search ────────────────────────────────────────────
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(),
        ),

        // ── Right side action buttons ─────────────────────────────────────────
        Positioned(
          right: 14,
          bottom: 100,
          child: _SideActions(
            liked: _liked,
            saved: _saved,
            onLike: () => setState(() => _liked = !_liked),
            onSave: () => setState(() => _saved = !_saved),
          ),
        ),

        // ── Bottom movie info ─────────────────────────────────────────────────
        Positioned(
          left: 18,
          right: 80,
          bottom: 30,
          child: _MovieInfo(movie: widget.movie),
        ),
      ],
    );
  }
}

// ─── Poster background ─────────────────────────────────────────────────────────

class _PosterBackground extends StatelessWidget {
  final String url;
  const _PosterBackground({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      // Fallback if no poster URL
      return Container(
        color: const Color(0xFF111111),
        child: const Center(
          child: Icon(Icons.movie, color: Color(0xFF05FFD1), size: 80),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF111111),
          child: const Center(
            child: Icon(Icons.broken_image_outlined,
                color: Color(0xFF05FFD1), size: 60),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF05FFD1)),
          ),
        );
      },
    );
  }
}

// ─── Top Bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo text
            const Text(
              'CINESCROLL',
              style: TextStyle(
                color: Color(0xFF05FFD1),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            // Search icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Side Action Buttons ───────────────────────────────────────────────────────

class _SideActions extends StatelessWidget {
  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;

  const _SideActions({
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like button
        _ActionBtn(
          icon: liked ? Icons.favorite : Icons.favorite_border,
          label: 'Like',
          color: liked ? Colors.redAccent : Colors.white,
          onTap: onLike,
        ),
        const SizedBox(height: 22),
        // Save button
        _ActionBtn(
          icon: saved ? Icons.bookmark : Icons.bookmark_border,
          label: 'Save',
          color: saved ? const Color(0xFF05FFD1) : Colors.white,
          onTap: onSave,
        ),
        const SizedBox(height: 22),
        // Share button (no logic yet)
        _ActionBtn(
          icon: Icons.share_outlined,
          label: 'Share',
          color: Colors.white,
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─── Movie Info Section ────────────────────────────────────────────────────────

class _MovieInfo extends StatelessWidget {
  final MovieModel movie;
  const _MovieInfo({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Movie title
        Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        // Star rating row
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFF05FFD1), size: 16),
            const SizedBox(width: 4),
            Text(
              movie.rating.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(width: 10),
            Text(
              movie.releaseDate.length >= 4
                  ? movie.releaseDate.substring(0, 4)
                  : movie.releaseDate,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Description (2 lines max)
        Text(
          movie.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),

        const SizedBox(height: 14),

        // Watch Now button
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF05FFD1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'WATCH NOW',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
