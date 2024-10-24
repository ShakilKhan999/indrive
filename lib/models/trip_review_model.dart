class TripReview {
  final double rating;
  final String category;
  final String tripId;
  bool isDriver;
  final List<String> reviews;

  TripReview({
    required this.isDriver,
    required this.rating,
    required this.category,
    required this.tripId,
    required this.reviews,
  });

  // fromJson method
  factory TripReview.fromJson(Map<String, dynamic> json) {
    return TripReview(
      rating: json['rating'].toDouble(),
      isDriver: json['isDriver'],
      category: json['category'],
      tripId: json['tripId'],
      reviews: List<String>.from(json['reviews'] ?? []),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'isDriver': isDriver,
      'category': category,
      'tripId': tripId,
      'reviews': reviews,
    };
  }
}
