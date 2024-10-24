class TripReview {
  final double rating;
  final String category;
  final String tripId;
  final List<String> reviews;

  TripReview({
    required this.rating,
    required this.category,
    required this.tripId,
    required this.reviews,
  });

  // fromJson method
  factory TripReview.fromJson(Map<String, dynamic> json) {
    return TripReview(
      rating: json['rating'].toDouble(),
      category: json['category'],
      tripId: json['tripId'],
      reviews: List<String>.from(json['reviews'] ?? []),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'category': category,
      'tripId': tripId,
      'reviews': reviews,
    };
  }
}
