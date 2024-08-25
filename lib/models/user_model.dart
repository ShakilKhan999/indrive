import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photo;
  String? lat;
  String? long;
  String? phone;
  String? signInWith;
  String? vehicleType;
  double? vehicleAngle;
  GeoPoint? latLng;
  bool? isDriver;
  bool? driverStatus;
  String? driverStatusDescription;
  String? driverVehicleType;
  bool? isCityToCity;
  bool? cityToCityStatus;
  bool? cityToCityStatusDescription;
  String? cityToCityVehicleType;
  bool? isCourier;
  bool? courierStatus;
  String? courierStatusDescription;
  String? courierVehicleType;
  bool? isFreight;
  bool? freightStatus;
  String? freightStatusDescription;
  String? freightVehicleType;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photo,
    this.lat,
    this.long,
    this.phone,
    this.signInWith,
    this.vehicleType,
    this.vehicleAngle,
    this.latLng,
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
      'phone': phone,
      'signInWith': signInWith,
      'vehicleType': vehicleType,
      'vehicleAngle': vehicleAngle,
      'latlng': latLng,
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
      phone: json['phone'],
      signInWith: json['signInWith'],
      vehicleType: json['vehicleType'],
      vehicleAngle: json['vehicleAngle'],
      latLng: json['latlng'],
      isDriver: json['isDriver'],
      driverStatus: json['driverStatus'],
      driverStatusDescription: json['driverStatusDescription'],
      driverVehicleType: json['driverVehicleType'],
      isCityToCity: json['isCityToCity'],
      cityToCityStatus: json['cityToCityStatus'],
      cityToCityStatusDescription: json['cityToCityStatusDescription'],
      cityToCityVehicleType: json['cityToCityVehicleType'],
      isCourier: json['isCourier'],
      courierStatus: json['courierStatus'],
      courierStatusDescription: json['courierStatusDescription'],
      courierVehicleType: json['courierVehicleType'],
      isFreight: json['isFreight'],
      freightStatus: json['freightStatus'],
      freightStatusDescription: json['freightStatusDescription'],
      freightVehicleType: json['freightVehicleType'],
    );
  }
}
