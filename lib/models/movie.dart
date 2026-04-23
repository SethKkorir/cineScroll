class MovieModel {
  final int id;
  final String title;
  final String description;
  final String posterUrl;
  // final String videoId;
  final String VideoUrl;
  final String sourceType;
  final String releaseDate;
  final double rating;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    // required this.videoId,
    required this.VideoUrl,
    required this.posterUrl,
    required this.sourceType,
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
      // videoId: json['video_url'] ?? '',
      VideoUrl: json['video_url'] ?? '',
      sourceType: json['source_type'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      releaseDate: json['release_date'] ?? '',
      rating: parsedRating,
    );
  }
}
