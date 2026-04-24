import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'logincontroller.dart';

class MovieController extends GetxController {
  // --- DATA ---
  var movies = <MovieModel>[].obs;
  var watchlist = <MovieModel>[].obs;
  var isLoading = true.obs;

  // --- NAVIGATION TRACKING ---
  var currentTabIndex = 0.obs;
  var selectedMovieIndex = 0.obs;

  // --- SERVER URL ---

  final String baseUrl = "http://10.7.28.8:3000";

  // --- DEMO MOVIE (Local) ---
  final MovieModel local1 = MovieModel(
    id: 1,
    title: "CINESCROLL EXCLUSIVE",
    description: "Welcome to the premium cinematic experience.",
    videoUrl: "assets/video.mp4",
    posterUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1025",
    sourceType: "local",
    releaseDate: "2024",
    rating: 5.0,
  );

  @override
  void onInit() {
    super.onInit();
    loadMovies(); // Get movies from DB on startup
    setupAutoSync(); // Automatically fetch watchlist after login
  }

  // This part automatically watches for when a user logs in
  void setupAutoSync() {
    try {
      final loginController = Get.find<LoginController>();
      ever(loginController.userId, (int uid) {
        if (uid != 0) {
          debugPrint("Login detected. Syncing watchlist...");
          fetchWatchlist();
        } else {
          watchlist.clear();
        }
      });
    } catch (e) {
      debugPrint("LoginController not found yet");
    }
  }

  // 1. Load All Movies from Server
  Future<void> loadMovies() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        List<MovieModel> dbMovies = data.map((m) => MovieModel.fromJson(m)).toList();
        
        // Combine local demo + database movies
        movies.assignAll([local1, ...dbMovies]);
      }
    } catch (e) {
      debugPrint("Server down, using local only: $e");
      movies.assignAll([local1]); 
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Get the User's Watchlist from Server
  Future<void> fetchWatchlist() async {
    final uid = Get.find<LoginController>().userId.value;
    if (uid == 0) return;

    try {
      final response = await http.get(Uri.parse('$baseUrl/watchlist/$uid'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        watchlist.assignAll(data.map((m) => MovieModel.fromJson(m)).toList());
        debugPrint("Watchlist loaded: ${watchlist.length} items");
      }
    } catch (e) {
      debugPrint("Watchlist fetch error: $e");
    }
  }

  // 3. Save or Remove from Watchlist
  Future<void> toggleWatchlist(MovieModel movie) async {
    final uid = Get.find<LoginController>().userId.value;

    if (uid == 0) {
      Get.snackbar("LOGIN REQUIRED", "Please sign in to save movies",
          backgroundColor: Colors.white, colorText: Colors.black);
      return;
    }

    // Logic: If already in list, REMOVE it. Otherwise, ADD it.
    if (isInWatchlist(movie)) {
      watchlist.removeWhere((m) => m.id == movie.id && m.sourceType == movie.sourceType);
      
      // Tell the database to delete it too
      if (movie.sourceType != "local") {
        http.delete(Uri.parse('$baseUrl/watchlist/$uid/${movie.id}'));
      }
    } else {
      watchlist.add(movie);
      
      // Tell the database to save it too
      if (movie.sourceType != "local") {
        http.post(
          Uri.parse('$baseUrl/watchlist'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': uid, 'movieId': movie.id}),
        );
      }
    }
  }

  // Helper to check if a movie is saved
  bool isInWatchlist(MovieModel movie) {
    return watchlist.any((m) => m.id == movie.id && m.sourceType == movie.sourceType);
  }
}
