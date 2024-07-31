class DriverInfoModel {
  String? id;
  String? profilePhoto;
  String? firstName;
  String? lastName;
  String? email;
  String? dateOfBirth;
  String? driverLicense;
  String? driverLicenseFrontPhoto;
  String? driverLicenseBackPhoto;
  String? idWithPhoto;
  String? nid;
  String? vehicleBrand;
  String? vehicleModelNo;
  String? vehicleNumberOfSeat;
  String? vehicleColor;
  String vehicleType;
  DriverInfoModel({
    this.id,
    this.profilePhoto,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.driverLicense,
    this.driverLicenseFrontPhoto,
    this.driverLicenseBackPhoto,
    this.idWithPhoto,
    this.nid,
    this.vehicleBrand,
    this.vehicleModelNo,
    this.vehicleNumberOfSeat,
    this.vehicleColor,
    required this.vehicleType,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverInfoModel(
      id: json['id'],
      profilePhoto: json['profilePhoto'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'],
      driverLicense: json['driverLicense'],
      driverLicenseFrontPhoto: json['driverLicenseFrontPhoto'],
      driverLicenseBackPhoto: json['driverLicenseBackPhoto'],
      idWithPhoto: json['idWithPhoto'],
      nid: json['nid'],
      vehicleBrand: json['vehicleBrand'],
      vehicleModelNo: json['vehicleModelNo'],
      vehicleNumberOfSeat: json['vehicleNumberOfSeat'],
      vehicleColor: json['vehicleColor'],
      vehicleType: json['vehicleType']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profilePhoto': profilePhoto,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'driverLicense': driverLicense,
      'driverLicenseFrontPhoto': driverLicenseFrontPhoto,
      'driverLicenseBackPhoto': driverLicenseBackPhoto,
      'idWithPhoto': idWithPhoto,
      'nid': nid,
      'vehicleBrand': vehicleBrand,
      'vehicleModelNo': vehicleModelNo,
      'vehicleNumberOfSeat': vehicleNumberOfSeat,
      'vehicleColor': vehicleColor,
      'vehicleType': vehicleType,
    };
  }
}
