class MovieModel {
  final int id;
  final String title;
  final String description;
  final String posterUrl;
  final String videoUrl;
  final String releaseDate;
  final double rating;
  final String sourceType;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.videoUrl,
    required this.releaseDate,
    required this.rating,
    this.sourceType = "network",
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    double parseRating(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseId(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return MovieModel(
      id: parseId(json['id']),
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      posterUrl: (json['posterUrl'] ?? json['poster_url'] ?? '').toString(),
      videoUrl: (json['videoUrl'] ?? json['video_url'] ?? '').toString(),
      releaseDate: (json['releaseDate'] ?? json['release_date'] ?? '').toString(),
      rating: parseRating(json['rating']),
      sourceType: (json['sourceType'] ?? json['source_type'] ?? 'network').toString(),
    );
  }
}
