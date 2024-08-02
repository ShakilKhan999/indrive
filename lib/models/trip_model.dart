import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String tripId;
  String? userId;
  String? driverId;
  String? destination;
  GeoPoint? pickLatLng;
  GeoPoint? dropLatLng;
  bool driverCancel;
  bool userCancel;
  bool accepted;
  bool picked;
  bool dropped;

  Trip({
    required this.tripId,
    this.userId,
    this.driverId,
    this.destination,
    this.pickLatLng,
    this.dropLatLng,
    required this.driverCancel,
    required this.userCancel,
    required this.accepted,
    required this.picked,
    required this.dropped,
  });

  // Convert a Firestore document to a Trip object
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] as String,
      userId: json['userId'] as String?,
      driverId: json['driverId'] as String?,
      destination: json['destination'] as String?,
      pickLatLng: json['pickLatLng'] != null
          ? json['pickLatLng'] as GeoPoint
          : null,
      dropLatLng: json['dropLatLng'] != null
          ? json['dropLatLng'] as GeoPoint
          : null,
      driverCancel: json['driverCancel'] as bool,
      userCancel: json['userCancel'] as bool,
      accepted: json['accepted'] as bool,
      picked: json['picked'] as bool,
      dropped: json['dropped'] as bool,
    );
  }

  // Convert a Trip object to a Firestore document
  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'userId': userId,
      'driverId': driverId,
      'destination': destination,
      'pickLatLng': pickLatLng,
      'dropLatLng': dropLatLng,
      'driverCancel': driverCancel,
      'userCancel': userCancel,
      'accepted': accepted,
      'picked': picked,
      'dropped': dropped,
    };
  }
}
