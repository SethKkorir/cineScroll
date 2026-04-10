import 'dart:convert';
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
      // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/movies'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        movies.value = data.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch movies");
      }
    } catch (e) {
      Get.snackbar("Error", "Connection failed: $e");
    } finally {
      isLoading(false);
    }
  }
}
