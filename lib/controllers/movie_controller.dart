import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'logincontroller.dart';

class MovieController extends GetxController {
  var movies = <MovieModel>[].obs;
  var isLoading = true.obs;
  var watchlist = <MovieModel>[].obs;

  final String baseUrl = "http://10.7.11.220:3000";

  // The 2 Local Movies
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

  final MovieModel local2 = MovieModel(
    id: 2,
    title: "GREENLAND: MIGRATION",
    description: "The countdown to extinction begins.",
    videoUrl: "assets/video2.mp4",
    posterUrl: "https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=1000",
    sourceType: "local",
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
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies'));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        List<MovieModel> fromDb = data.map((m) => MovieModel.fromJson(m)).toList();
        var top5FromDb = fromDb.take(5).toList();
        movies.assignAll([local1, local2, ...top5FromDb]);
        
        // After loading movies, if we are logged in, fetch the watchlist
        fetchWatchlist();
      } else {
        movies.assignAll([local1, local2]);
      }
    } catch (e) {
      debugPrint("Error loading movies: $e");
      movies.assignAll([local1, local2]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWatchlist() async {
    final loginController = Get.find<LoginController>();
    int uid = loginController.userId.value;
    if (uid == 0) return;

    try {
      final response = await http.get(Uri.parse('$baseUrl/watchlist/$uid'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        watchlist.assignAll(data.map((m) => MovieModel.fromJson(m)).toList());
      }
    } catch (e) {
      debugPrint("Error fetching watchlist: $e");
    }
  }

  Future<void> toggleWatchlist(MovieModel movie) async {
    final loginController = Get.find<LoginController>();
    int uid = loginController.userId.value;

    if (uid == 0) {
      Get.snackbar("Notice", "Please login to save movies", 
        backgroundColor: Colors.white, colorText: Colors.black);
      return;
    }

    // Don't save local movies to the database
    if (movie.sourceType == "local") {
      if (watchlist.any((m) => m.id == movie.id && m.sourceType == "local")) {
        watchlist.removeWhere((m) => m.id == movie.id && m.sourceType == "local");
      } else {
        watchlist.add(movie);
      }
      return;
    }

    // Handle database movies
    bool alreadyIn = watchlist.any((m) => m.id == movie.id && m.sourceType != "local");

    if (alreadyIn) {
      // Remove from server
      watchlist.removeWhere((m) => m.id == movie.id);
      try {
        await http.delete(Uri.parse('$baseUrl/watchlist/$uid/${movie.id}'));
      } catch (e) {
        debugPrint("Error removing from watchlist: $e");
      }
    } else {
      // Add to server
      watchlist.add(movie);
      try {
        await http.post(
          Uri.parse('$baseUrl/watchlist'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': uid, 'movieId': movie.id}),
        );
      } catch (e) {
        debugPrint("Error adding to watchlist: $e");
      }
    }
  }

  bool isInWatchlist(MovieModel movie) {
    return watchlist.any((m) => m.id == movie.id && m.sourceType == movie.sourceType);
  }
}
