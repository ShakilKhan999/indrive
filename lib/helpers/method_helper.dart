import 'dart:developer';
import 'dart:io';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/models/trip_review_model.dart';
import 'package:callandgo/models/user_model.dart';
import 'package:callandgo/screens/home/repository/passenger_repositoy.dart';
import 'package:callandgo/utils/database_collection_names.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/vehicle_model.dart';

class MethodHelper {
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<String?> uploadImage(
      {required File file, required String imageLocationName}) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("$imageLocationName/$fileName");
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Error when uploading image : $e');
      return null;
    }
  }

  Future<bool> updateDocFields(
      {required String docId,
      required Map<String, dynamic> fieldsToUpdate,
      required String collection}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection(collection);
      await users.doc(docId).update(fieldsToUpdate);
      return true;
    } catch (e) {
      log('Error updating user fields: $e');
      return false;
    }
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String getLocationFromLatLng({required List<Placemark> placemarks}) {
    String location = '';
    String name = '';
    String subLocality = '';
    String locality = '';
    try {
      for (int i = 0; i < placemarks.length; i++) {
        if (placemarks[i].name != null || placemarks[i].name != '') {
          if (placemarks[i].name!.length > name.length) {
            name = placemarks[i].name!;
          }
        }

        if (subLocality == '') {
          if (placemarks[i].subLocality != null ||
              placemarks[i].subLocality != '') {
            subLocality = placemarks[i].subLocality!;
          }
        }
        if (locality == '') {
          if (placemarks[i].locality != null || placemarks[i].locality != '') {
            locality = placemarks[i].locality!;
          }
        }
      }
    } catch (e) {
      log('Error getting location from latitude and longitude: $e');
    }
    location = '$name, $subLocality, $locality';
    return location;
  }

  String formatedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formatedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formatedDate;
  }

  static String joinStringsWithComma(String str1, String str2) {
    return '$str1, $str2';
  }

  Future<void> cancelRide(String collectionName, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
      print("Document deleted successfully!");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  Stream<UserModel> listerUserData({required String userId}) {
    return FirebaseFirestore.instance
        .collection(userCollection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  sortTripsByCreatedAt(List trips) {
    trips.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt);
      DateTime dateB = DateTime.parse(b.createdAt);
      return dateB.compareTo(dateA); // Reversed the comparison
    });
  }

  Color statusColor({required String status}) {
    Color color = Colors.white;
    if (status == 'accepted') {
      color = Colors.green;
    } else if (status == 'cancelled') {
      color = Colors.red;
    } else if (status == 'completed') {
      color = Colors.blue;
    } else if (status == 'picked up') {
      color = Colors.yellow;
    }
    return color;
  }

  Future<LatLng> getUserLocation() async {
    log("getUserLocation called");
    try {
      Position position = await getCurrentLocation();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      log('Failed to get location: $e');
      return LatLng(0, 0);
    }
  }

  Future<Position> getCurrentLocation() async {
    log("getCurrentLocation called");

    checkLocationServiceAndPermission();
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> checkLocationServiceAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
  }

  String timeAgo(String dateTime) {
    final createdDateTime = DateTime.parse(dateTime);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(createdDateTime);

    if (difference.inDays >= 1) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }

  Future<void> makePhoneCall(String? phoneNumber) async {
    fToast.init(Get.context!);
    if (phoneNumber == null) {
      showToast(
          toastText: 'Phone call not available', toastColor: ColorHelper.red);
      return;
    }
    if (phoneNumber.toLowerCase() == 'none') {
      showToast(
          toastText: 'Phone call not available', toastColor: ColorHelper.red);
      return;
    } else {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  Stream<double> getAverageRating(String userId, bool isDriver) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Reviews')
        .where('isDriver', isEqualTo: isDriver) // Filter by isDriver
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        double totalRating = snapshot.docs.fold(0.0, (sum, doc) {
          return sum + (doc.data()['rating'] as double);
        });
        return totalRating / snapshot.docs.length;
      } else {
        return 3.0; // Default rating if no documents found
      }
    });
  }


  Future<List<VehicleModel>> getVehicleBrands(
      {required String collection}) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection(collection).get();

      return snapshot.docs
          .map((doc) => VehicleModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Error while getting vehicle models: $e');
      return [];
    }
  }
  var loading=false.obs;
  Future<void> addTripReview({required String userId,required TripReview tripReview}) async{
    loading.value=true;
    await PassengerRepository().addTripReview(userId: userId, tripReview: tripReview);
    loading.value=false;
  }
}
