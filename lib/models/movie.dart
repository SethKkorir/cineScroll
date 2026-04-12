class MovieModel {
  final int id;
  final String title;
  final String description;
  final String posterUrl;
  final String videoUrl;
  final String releaseDate;
  final double rating;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.videoUrl,
    required this.releaseDate,
    required this.rating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    double parsedRating = 0.0;
    if (json['rating'] != null) {
      if (json['rating'] is String) {
        parsedRating = double.tryParse(json['rating']) ?? 0.0;
      } else {
        parsedRating = (json['rating'] as num).toDouble();
      }
    }

    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      releaseDate: json['release_date'] ?? '',
      rating: parsedRating,
    );
  }
}
