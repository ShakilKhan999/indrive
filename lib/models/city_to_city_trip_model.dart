import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class CityToCityTripModel {
  final String? id;
  final String? cityFrom;
  final String? cityTo;
  final String? date;
  final String? userPrice;
  final String? finalPrice;
  final int? numberOfPassengers;
  final String? userPhone;
  final String? userName;
  final String? userImage;
  final String? driverPhone;
  final String? driverName;
  final String? driverImage;
  final String? driverVehicle;
  final String? userUid;
  final String? driverUid;
  final List<Bids>? bids;
  final bool? isTripCompleted;
  final bool? isTripCancelled;
  final bool? isTripAccepted;
  final String? tripCurrentStatus;
  final String? tripType;
  final String? description;
  final GeoPoint? pickLatLng;
  final GeoPoint? dropLatLng;
  final String? acceptBy;
  final String? declineDriverIds;

  CityToCityTripModel({
    this.id,
    this.cityFrom,
    this.cityTo,
    this.date,
    this.userPrice,
    this.finalPrice,
    this.numberOfPassengers,
    this.userPhone,
    this.userName,
    this.userImage,
    this.driverPhone,
    this.driverName,
    this.driverImage,
    this.driverVehicle,
    this.userUid,
    this.driverUid,
    this.bids,
    this.isTripCompleted,
    this.isTripCancelled,
    this.isTripAccepted,
    this.tripCurrentStatus,
    this.tripType,
    this.description,
    this.pickLatLng,
    this.dropLatLng,
    this.acceptBy,
    this.declineDriverIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityFrom': cityFrom,
      'cityTo': cityTo,
      'date': date,
      'userPrice': userPrice,
      'finalPrice': finalPrice,
      'numberOfPassengers': numberOfPassengers,
      'userPhone': userPhone,
      'userName': userName,
      'userImage': userImage,
      'driverPhone': driverPhone,
      'driverName': driverName,
      'driverImage': driverImage,
      'driverVehicle': driverVehicle,
      'userUid': userUid,
      'driverUid': driverUid,
      'bids': bids?.map((bid) => bid.toJson()).toList(),
      'isTripCompleted': isTripCompleted,
      'isTripCancelled': isTripCancelled,
      'isTripAccepted': isTripAccepted,
      'tripCurrentStatus': tripCurrentStatus,
      'tripType': tripType,
      'description': description,
      'pickLatLng': pickLatLng,
      'dropLatLng': dropLatLng,
      'acceptBy': acceptBy,
      'declineDriverIds': declineDriverIds,
    };
  }

  factory CityToCityTripModel.fromJson(Map<String, dynamic> json) {
    return CityToCityTripModel(
      id: json['id'],
      cityFrom: json['cityFrom'],
      cityTo: json['cityTo'],
      date: json['date'],
      userPrice: json['userPrice'],
      finalPrice: json['finalPrice'],
      numberOfPassengers: json['numberOfPassengers'],
      userPhone: json['userPhone'],
      userName: json['userName'],
      userImage: json['userImage'],
      driverPhone: json['driverPhone'],
      driverName: json['driverName'],
      driverImage: json['driverImage'],
      driverVehicle: json['driverVehicle'],
      userUid: json['userUid'],
      driverUid: json['driverUid'],
      bids: (json['bids'] as List<dynamic>?)
          ?.map((bidJson) => Bids.fromJson(bidJson))
          .toList(),
      isTripCompleted: json['isTripCompleted'] ?? false,
      isTripCancelled: json['isTripCancelled'] ?? false,
      isTripAccepted: json['isTripAccepted'] ?? false,
      tripCurrentStatus: json['tripCurrentStatus'],
      tripType: json['tripType'],
      description: json['description'],
      pickLatLng: json['pickLatLng'],
      dropLatLng: json['dropLatLng'],
      acceptBy: json['acceptBy'],
      declineDriverIds: json['declineDriverIds'],
    );
  }
}

class Bids {
  final String? driverPrice;
  final String? driverPhone;
  final String? driverName;
  final String? driverImage;
  final String? driverVehicle;
  final String? driverUid;

  Bids({
    this.driverPrice,
    this.driverPhone,
    this.driverName,
    this.driverImage,
    this.driverVehicle,
    this.driverUid,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverPrice': driverPrice,
      'driverPhone': driverPhone,
      'driverName': driverName,
      'driverImage': driverImage,
      'driverVehicle': driverVehicle,
      'driverUid': driverUid,
    };
  }

  factory Bids.fromJson(Map<String, dynamic> json) {
    return Bids(
      driverPrice: json['driverPrice'],
      driverPhone: json['driverPhone'],
      driverName: json['driverName'],
      driverImage: json['driverImage'],
      driverVehicle: json['driverVehicle'],
      driverUid: json['driverUid'],
    );
  }
}
