import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/movie.dart';

class MovieController extends GetxController {
  var movies = <MovieModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      isLoading(true);
      debugPrint("--- Fetching Movies from Backend ---");
      
      // Logic to switch between emulator IP and localhost for Web
      String url = kIsWeb ? 'http://localhost:3000/movies' : 'http://10.0.2.2:3000/movies';
      debugPrint("Request URL: $url");

      final response = await http.get(Uri.parse(url));

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        movies.value = data.map((json) => MovieModel.fromJson(json)).toList();
        debugPrint("Successfully loaded ${movies.length} movies into the list.");
      } else {
        debugPrint("Error: Server returned status ${response.statusCode}");
        Get.snackbar("Error", "Failed to fetch movies from server");
      }
    } catch (e) {
      debugPrint("Network Exception: $e");
      Get.snackbar("Error", "Could not connect to the backend: $e");
    } finally {
      isLoading(false);
    }
  }
}
