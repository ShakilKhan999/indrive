import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photo;
  String? lat;
  String? long;
  String? userLocation;
  String? phone;
  String? signInWith;
  String? vehicleType;
  double? vehicleAngle;
  GeoPoint? latLng;
  bool? isDriverMode;
  bool? isDriver;
  String? driverStatus;
  String? driverStatusDescription;
  String? driverVehicleType;
  bool? isCityToCity;
  String? cityToCityStatus;
  String? cityToCityStatusDescription;
  String? cityToCityVehicleType;
  bool? isCourier;
  String? courierStatus;
  String? courierStatusDescription;
  String? courierVehicleType;
  bool? isFreight;
  String? freightStatus;
  String? freightStatusDescription;
  String? freightVehicleType;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photo,
    this.lat,
    this.long,
    this.userLocation,
    this.phone,
    this.signInWith,
    this.vehicleType,
    this.vehicleAngle,
    this.latLng,
    this.isDriverMode,
    this.isDriver,
    this.driverStatus,
    this.driverStatusDescription,
    this.driverVehicleType,
    this.isCityToCity,
    this.cityToCityStatus,
    this.cityToCityStatusDescription,
    this.cityToCityVehicleType,
    this.isCourier,
    this.courierStatus,
    this.courierStatusDescription,
    this.courierVehicleType,
    this.isFreight,
    this.freightStatus,
    this.freightStatusDescription,
    this.freightVehicleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photo': photo,
      'lat': lat,
      'long': long,
      'userLocation': userLocation,
      'phone': phone,
      'signInWith': signInWith,
      'vehicleType': vehicleType,
      'vehicleAngle': vehicleAngle,
      'latlng': latLng,
      'isDriverMode': isDriverMode,
      'isDriver': isDriver,
      'driverStatus': driverStatus,
      'driverStatusDescription': driverStatusDescription,
      'driverVehicleType': driverVehicleType,
      'isCityToCity': isCityToCity,
      'cityToCityStatus': cityToCityStatus,
      'cityToCityStatusDescription': cityToCityStatusDescription,
      'cityToCityVehicleType': cityToCityVehicleType,
      'isCourier': isCourier,
      'courierStatus': courierStatus,
      'courierStatusDescription': courierStatusDescription,
      'courierVehicleType': courierVehicleType,
      'isFreight': isFreight,
      'freightStatus': freightStatus,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      lat: json['lat'],
      long: json['long'],
      userLocation: json['userLocation'],
      phone: json['phone'],
      signInWith: json['signInWith'],
      vehicleType: json['vehicleType'],
      vehicleAngle: json['vehicleAngle'],
      latLng: json['latlng'],
      isDriverMode: json['isDriverMode'] ?? false,
      isDriver: json['isDriver'] ?? false,
      driverStatus: json['driverStatus'],
      driverStatusDescription: json['driverStatusDescription'],
      driverVehicleType: json['driverVehicleType'],
      isCityToCity: json['isCityToCity'] ?? false,
      cityToCityStatus: json['cityToCityStatus'],
      cityToCityStatusDescription: json['cityToCityStatusDescription'],
      cityToCityVehicleType: json['cityToCityVehicleType'],
      isCourier: json['isCourier'] ?? false,
      courierStatus: json['courierStatus'],
      courierStatusDescription: json['courierStatusDescription'],
      courierVehicleType: json['courierVehicleType'],
      isFreight: json['isFreight'] ?? false,
      freightStatus: json['freightStatus'],
      freightStatusDescription: json['freightStatusDescription'],
      freightVehicleType: json['freightVehicleType'],
    );
  }
}
