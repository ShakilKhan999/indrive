import 'package:cloud_firestore/cloud_firestore.dart';

class CourierTripModel {
  final String? id;
  final List? transportOptionList;
  final String? from;
  final String? to;
  final String? date;
  final String? truckSize;
  final String? cargoImage;
  final String? userPrice;
  final String? finalPrice;
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
  final GeoPoint? pickLatLng;
  final GeoPoint? dropLatLng;
  final String? acceptBy;
  final String? declineDriverIds;
  final String? cancelReason;
  final String? cancelBy;
  final String? createdAt;
  final bool? isDoorToDoor;
  final String? senderPhone;
  final String? pickupFullAddress;
  final String? pickupHomeAddress;
  final String? recipientPhone;
  final String? destinationFullAddress;
  final String? destinationHomeAddress;
  final String? description;

  CourierTripModel({
    this.id,
    this.transportOptionList,
    this.from,
    this.to,
    this.date,
    this.truckSize,
    this.cargoImage,
    this.userPrice,
    this.finalPrice,
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
    this.pickLatLng,
    this.dropLatLng,
    this.acceptBy,
    this.declineDriverIds,
    this.cancelReason,
    this.cancelBy,
    required this.createdAt,
    this.isDoorToDoor,
    this.senderPhone,
    this.pickupFullAddress,
    this.pickupHomeAddress,
    this.recipientPhone,
    this.destinationFullAddress,
    this.destinationHomeAddress,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transportOptionList': transportOptionList,
      'from': from,
      'to': to,
      'userPrice': userPrice,
      'finalPrice': finalPrice,
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
      'pickLatLng': pickLatLng,
      'dropLatLng': dropLatLng,
      'acceptBy': acceptBy,
      'declineDriverIds': declineDriverIds,
      'cancelReason': cancelReason,
      'cancelBy': cancelBy,
      'createdAt': createdAt,
      'isDoorToDoor': isDoorToDoor,
      'senderPhone': senderPhone,
      'pickupFullAddress': pickupFullAddress,
      'pickupHomeAddress': pickupHomeAddress,
      'recipientPhone': recipientPhone,
      'destinationFullAddress': destinationFullAddress,
      'destinationHomeAddress': destinationHomeAddress,
      'description': description,
    };
  }

  factory CourierTripModel.fromJson(Map<String, dynamic> json) {
    return CourierTripModel(
      id: json['id'],
      transportOptionList: json['transportOptionList']! as List<dynamic>?,
      from: json['from'],
      to: json['to'],
      date: json['date'],
      truckSize: json['truckSize'],
      cargoImage: json['cargoImage'],
      userPrice: json['userPrice'],
      finalPrice: json['finalPrice'],
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
      pickLatLng: json['pickLatLng'],
      dropLatLng: json['dropLatLng'],
      acceptBy: json['acceptBy'],
      declineDriverIds: json['declineDriverIds'],
      cancelReason: json['cancelReason'],
      cancelBy: json['cancelBy'],
      createdAt: json['createdAt'],
      isDoorToDoor: json['isDoorToDoor'],
      senderPhone: json['senderPhone'],
      pickupFullAddress: json['pickupFullAddress'],
      pickupHomeAddress: json['pickupHomeAddress'],
      recipientPhone: json['recipientPhone'],
      destinationFullAddress: json['destinationFullAddress'],
      destinationHomeAddress: json['destinationHomeAddress'],
      description: json['description'],
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
