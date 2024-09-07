import 'package:cloud_firestore/cloud_firestore.dart';

class Bid {
  String? driverId;
  String? driverOffer;
  String? driverName;
  String? driverPhoto;
  double? offerPrice;
  bool? driverAccept;
  bool? driverDecline;
  DateTime? bidStart;
  DateTime? tripCalled;

  Bid({
    this.driverId,
    this.offerPrice,
    this.driverOffer,
    this.driverName,
    this.driverPhoto,
    this.driverAccept,
    this.driverDecline,
    this.bidStart,
    this.tripCalled,
  });

  // Convert a Firestore document to a Bid object
  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      driverId: json['driverId'] as String?,
      offerPrice: json['offerPrice'] as double?,
      driverOffer: json['driverOffer'] as String?,
      driverName: json['driverName'] as String?,
      driverPhoto: json['driverPhoto'] as String?,
      driverAccept: json['driverAccept'] as bool?,
      driverDecline: json['driverDecline'] as bool?,
      bidStart: json['bidStart'] != null
          ? (json['bidStart'] as Timestamp).toDate()
          : null,
      tripCalled: json['tripCalled'] != null
          ? (json['tripCalled'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert a Bid object to a Firestore document
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'offerPrice': offerPrice,
      'driverOffer': driverOffer,
      'driverName': driverName,
      'driverPhoto': driverPhoto,
      'driverAccept': driverAccept,
      'driverDecline': driverDecline,
      'bidStart': bidStart != null ? Timestamp.fromDate(bidStart!) : null,
      'tripCalled': tripCalled != null ? Timestamp.fromDate(tripCalled!) : null,
    };
  }
}

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
  int? rent;
  List<Bid>? bids; // New field added for list of bids

  Trip({
    required this.tripId,
    this.userId,
    this.rent,
    this.driverId,
    this.destination,
    this.pickLatLng,
    this.dropLatLng,
    required this.driverCancel,
    required this.userCancel,
    required this.accepted,
    required this.picked,
    required this.dropped,
    this.bids,
  });

  // Convert a Firestore document to a Trip object
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] as String,
      rent: json['rent'] as int,
      userId: json['userId'] as String?,
      driverId: json['driverId'] as String?,
      destination: json['destination'] as String?,
      pickLatLng:
          json['pickLatLng'] != null ? json['pickLatLng'] as GeoPoint : null,
      dropLatLng:
          json['dropLatLng'] != null ? json['dropLatLng'] as GeoPoint : null,
      driverCancel: json['driverCancel'] as bool,
      userCancel: json['userCancel'] as bool,
      accepted: json['accepted'] as bool,
      picked: json['picked'] as bool,
      dropped: json['dropped'] as bool,
      bids: (json['bids'] as List<dynamic>?)
          ?.map((e) => Bid.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert a Trip object to a Firestore document
  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'rent': rent,
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
      'bids': bids?.map((e) => e.toJson()).toList(),
    };
  }
}
