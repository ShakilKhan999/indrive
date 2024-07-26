import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indrive/models/user_model.dart';

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
}
