class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photo;
  bool? isDriver;
  String? lat;
  String? long;
  String? phone;
  String? signInWith;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photo,
    this.isDriver,
    this.lat,
    this.long,
    this.phone,
    this.signInWith,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photo': photo,
      'isDriver': isDriver,
      'lat': lat,
      'long': long,
      'phone': phone,
      'signInWith': signInWith,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      isDriver: json['isDriver'],
      lat: json['lat'],
      long: json['long'],
      phone: json['phone'],
      signInWith: json['signInWith'],
    );
  }
}
