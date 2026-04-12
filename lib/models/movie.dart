class MovieModel {
  final int id;
  final String title;
  final String description;
  final String posterUrl;
  final String releaseDate;
  final double rating;
  final String createdAt;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.releaseDate,
    required this.rating,
    required this.createdAt,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // Safely parse rating because MySQL DECIMAL often returns as a String "8.8"
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
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      releaseDate: json['release_date'] ?? '',
      rating: parsedRating,
      createdAt: json['created_at'] ?? '',
    );
  }
}
