import 'dart:developer';
import 'dart:io';
import 'package:callandgo/models/user_model.dart';
import 'package:callandgo/utils/database_collection_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';

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
}
