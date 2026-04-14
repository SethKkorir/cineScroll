import 'package:flutter/material.dart';
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
    
    debugPrint("--- Loading Movies (TEST MODE) ---");

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock Movie Data for testing UI
    final mockMovies = [
      MovieModel(
        id: 1,
        title: "Dune: Part Two",
        description: "Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family.",
        videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        posterUrl: "",
        rating: 8.8,
        releaseDate: "2024-03-01",
      ),
      MovieModel(
        id: 2,
        title: "The Batman",
        description: "Batman ventures into Gotham City's underworld when a sadistic killer leaves behind a trail of cryptic clues.",
        videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        posterUrl: "",
        rating: 7.9,
        releaseDate: "2022-03-04",
      ),
      MovieModel(
        id: 3,
        title: "Spider-Man: Across the Spider-Verse",
        description: "Miles Morales catapults across the Multiverse, where he encounters a team of Spider-People charged with protecting its very existence.",
        videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        posterUrl: "",
        rating: 8.7,
        releaseDate: "2023-06-02",
      ),
      MovieModel(
        id: 4,
        title: "Joker",
        description: "A mentally troubled stand-up comedian embarks on a downward spiral that leads to the creation of an iconic villain.",
        videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        posterUrl: "",
        rating: 8.4,
        releaseDate: "2019-10-04",
      ),
    ];

    movies.assignAll(mockMovies);
    isLoading.value = false;

    /*
    // REAL BACKEND MOVIE FETCH (Commented out for testing)
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/movies'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        movies.assignAll(data.map((m) => MovieModel.fromJson(m)).toList());
      }
    } catch (e) {
      debugPrint('Movie load error: $e');
    } finally {
      isLoading.value = false;
    }
    */
  }
}
