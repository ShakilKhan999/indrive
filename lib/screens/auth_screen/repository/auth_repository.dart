import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indrive/models/user_model.dart';

import '../../../models/driver_info_model.dart';
import '../../../utils/database_collection_names.dart';

class AuthRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<bool> saveUserData({required UserModel userModel}) async {
    try {
      await _db
          .collection(userCollection)
          .doc(userModel.uid)
          .set(userModel.toJson());
      return true;
    } catch (e) {
      log('Error while saving user data $e');
      return false;
    }
  }

  Future<bool> checkUserExistsOrNot({required String documentId}) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(documentId)
          .get();
      return documentSnapshot.exists;
    } catch (e) {
      log("Error checking document existence: $e");
      return false;
    }
  }

  Future<UserModel?> getUserById({required String userId}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection(userCollection);
      DocumentSnapshot snapshot = await users.doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        UserModel user = UserModel.fromJson(data);
        return user;
      } else {
        log('User does not exist');
        return null;
      }
    } catch (e) {
      log('Error getting document: $e');
      return null;
    }
  }

  Future<DriverInfoModel?> getCurrentUserDriverData(
      {required String userId}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(userId)
          .collection(driverDetials)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        DriverInfoModel driverInfo = DriverInfoModel.fromJson(data);
        return driverInfo;
      } else {
        print('No documents found in the collection');
        return null;
      }
    } catch (e) {
      print('Error fetching driver info: $e');
      return null;
    }
  }
}
