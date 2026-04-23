// lib/controllers/movie_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieController extends GetxController {
  var movies = <MovieModel>[].obs;
  var isLoading = true.obs;
  var watchlist = <MovieModel>[].obs;

  final String baseUrl = "http://10.7.11.220:3000";  // Your IP

  void toggleWatchlist(MovieModel movie) {
    if (watchlist.contains(movie)) {
      watchlist.remove(movie);
      Get.snackbar(
        "Removed",
        "${movie.title} removed from watchlist",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 2),
      );
    } else {
      watchlist.add(movie);
      Get.snackbar(
        "Added",
        "${movie.title} added to watchlist",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 2),
      );
    }
  }

  bool isInWatchlist(MovieModel movie) => watchlist.contains(movie);

  final MovieModel localMovie = MovieModel(
    id: 999,
    title: "CINESCROLL EXCLUSIVE",
    description: "Experience the premium cinematic feed. This video is served locally for maximum speed.",
    VideoUrl: "assets/video.mp4",
    // videoId: "local_video_999",
    sourceType: "local",
    posterUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1025",
    releaseDate: "2024",
    rating: 5.0,
  );

  final MovieModel localMovie2 = MovieModel(
    id: 998,
    title: "GREENLAND: MIGRATION",
    description: "The countdown to extinction begins. The Garrity family must find a new home in a frozen wasteland.",
    VideoUrl: "assets/video2.mp4",
    // videoId: "local_video_998",
    sourceType: "local",
    posterUrl: "https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=1000",
    releaseDate: "2024",
    rating: 4.8,
  );

  @override
  void onInit() {
    super.onInit();
    loadMovies();
  }

  Future<void> loadMovies() async {
    isLoading.value = true;
    debugPrint("=== Fetching Movies from Server ===");
    debugPrint("URL: $baseUrl/movies");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      debugPrint("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        debugPrint("Movies from database: ${data.length}");
        
        // Debug first movie
        if (data.isNotEmpty) {
          debugPrint("First movie data: ${data[0]}");
        }

        var fetchedMovies = data.map((m) => MovieModel.fromJson(m)).toList();
        movies.assignAll([localMovie, localMovie2, ...fetchedMovies]);
        
        debugPrint(" Success! Total movies: ${movies.length}");
        debugPrint("Local: 2, Database: ${fetchedMovies.length}");
      } else {
        debugPrint(" Server Error: ${response.statusCode}");
        debugPrint("Response: ${response.body}");
        movies.assignAll([localMovie, localMovie2]);
      }
    } catch (e) {
      debugPrint(" Connection Failed: $e");
      movies.assignAll([localMovie, localMovie2]);
      
      Get.snackbar(
        "Connection Error",
        "Using local videos only. Check your server.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadMovies();
  }
}