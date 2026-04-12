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
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/movies'));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        movies.assignAll(data.map((m) => MovieModel.fromJson(m)).toList());
      }
    } catch (e) {
      Get.snackbar("Sync Error", "Connection to library failed");
    } finally {
      isLoading(false);
    }
  }
}
