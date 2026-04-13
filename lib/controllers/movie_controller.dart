import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/movie.dart';

class MovieController extends GetxController {
  var movies = <MovieModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadMovies();
  }

  Future<void> loadMovies() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/movies'),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        movies.assignAll(data.map((m) => MovieModel.fromJson(m)).toList());
      } else {
        Get.snackbar('Error', 'Could not load movies',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint('Movie load error: $e');
      Get.snackbar('Connection Error', 'Make sure the server is running',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
