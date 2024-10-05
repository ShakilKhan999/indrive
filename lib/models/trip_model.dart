import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
  String? polyLineEncoded;
  String? userId;
  String? userName;
  String? userImage;
  String? userPhone;
  String? driverId;
  String? destination;
  String? pickUp;
  GeoPoint? pickLatLng;
  GeoPoint? dropLatLng;
  bool driverCancel;
  bool userCancel;
  bool accepted;
  bool picked;
  bool dropped;
  int? rent;
  List<Bid>? bids;
  List<Routes>? routes;

  Trip({
    required this.tripId,
    this.userId,
    this.userName,
    this.userImage,
    this.userPhone,
    this.polyLineEncoded,
    this.rent,
    this.driverId,
    this.destination,
    this.pickUp,
    this.pickLatLng,
    this.dropLatLng,
    required this.driverCancel,
    required this.userCancel,
    required this.accepted,
    required this.picked,
    required this.dropped,
    this.bids,
    this.routes,
  });

  // Convert a Firestore document to a Trip object
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] as String,
      polyLineEncoded: json['polyLineEncoded'] == null
          ? null
          : json['polyLineEncoded'] as String,
      rent: json['rent'] as int,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userPhone: json['userPhone'] as String?,
      userImage: json['userImage'] as String?,
      driverId: json['driverId'] as String?,
      destination: json['destination'] as String?,
      pickUp: json['pickUp'] as String?,
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
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => Routes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert a Trip object to a Firestore document
  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'polyLineEncoded': polyLineEncoded,
      'rent': rent,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'userPhone': userPhone,
      'driverId': driverId,
      'destination': destination,
      'pickUp': pickUp,
      'pickLatLng': pickLatLng,
      'dropLatLng': dropLatLng,
      'driverCancel': driverCancel,
      'userCancel': userCancel,
      'accepted': accepted,
      'picked': picked,
      'dropped': dropped,
      'bids': bids?.map((e) => e.toJson()).toList(),
      'routes': routes?.map((e) => e.toJson()).toList(),
    };
  }
}

class Routes {
  String? pickupPoint;
  GeoPoint? pickupLatLng;
  String? destinationPoint;
  GeoPoint? destinationLatLng;
  String? currentStatus;
  String? encodedPolyline;

  Routes({
    this.pickupPoint,
    this.pickupLatLng,
    this.destinationPoint,
    this.destinationLatLng,
    this.currentStatus,
    this.encodedPolyline,
  });

  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      pickupPoint: json['pickupPoint'] as String?,
      pickupLatLng:
          json['pickLatLng'] != null ? json['pickLatLng'] as GeoPoint : null,
      destinationPoint: json['destinationPoint'] as String?,
      destinationLatLng: json['destinationLatLng'] != null
          ? json['destinationLatLng'] as GeoPoint
          : null,
      currentStatus: json['currentStatus'] as String?,
      encodedPolyline: json['encodedPolyline'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupPoint': pickupPoint,
      'pickLatLng': pickupLatLng,
      'destinationPoint': destinationPoint,
      'destinationLatLng': destinationLatLng,
      'currentStatus': currentStatus,
      'encodedPolyline': encodedPolyline,
    };
  }
}
