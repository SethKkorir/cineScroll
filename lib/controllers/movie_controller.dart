import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieController extends GetxController {
  var movies = <MovieModel>[].obs;
  var isLoading = true.obs;

  final String baseUrl = "http://10.7.28.38:3000";

  // The local asset movie that should always be there
  final MovieModel localMovie = MovieModel(
    id: 999,
    title: "CINESCROLL EXCLUSIVE",
    description: "Experience the premium cinematic feed. This video is served locally for maximum speed.",
    videoId: "assets/video.mp4", // If this fails, we will try "/assets/video.mp4" next
    sourceType: "local",
    posterUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1025",
    releaseDate: "2024",
    rating: 5.0,
  );

  @override
  void onInit() {
    super.onInit();
    loadMovies();
  }

  Future<void> loadMovies() async {
    isLoading.value = true;
    debugPrint("--- Fetching Movies from Local Server ---");

    try {
      final response = await http.get(Uri.parse('$baseUrl/movies'));
      
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        var fetchedMovies = data.map((m) => MovieModel.fromJson(m)).toList();
        
        // Always add the local movie at the beginning
        movies.assignAll([localMovie, ...fetchedMovies]);
        debugPrint('Successfully connected to server. Total movies: ${movies.length}');
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        movies.assignAll([localMovie]); // Only local movie if server error
      }
    } catch (e) {
      debugPrint('Connection Failed: $e');
      movies.assignAll([localMovie]); // Only local movie if connection failed
    } finally {
      isLoading.value = false;
    }
  }
}
