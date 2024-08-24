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
  bool? isCityToCity;
  bool? cityToCityStatus;
  bool? isCourier;
  bool? courierStatus;
  bool? isFreight;
  bool? freightStatus;

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
    this.isCityToCity,
    this.cityToCityStatus,
    this.isCourier,
    this.courierStatus,
    this.isFreight,
    this.freightStatus,
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
      'isCityToCity': isCityToCity,
      'cityToCityStatus': cityToCityStatus,
      'isCourier': isCourier,
      'courierStatus': courierStatus,
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
      isCityToCity: json['isCityToCity'],
      cityToCityStatus: json['cityToCityStatus'], 
      isCourier: json['isCourier'],
      courierStatus: json['courierStatus'],
      isFreight: json['isFreight'],
      freightStatus: json['freightStatus'],
    );
  }
}
