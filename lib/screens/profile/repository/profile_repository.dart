import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:callandgo/utils/database_collection_names.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future getUserProfileData({required String userId}) async {
    try {
      return await _firestore.collection(userCollection).doc(userId).get();
    } catch (e) {
      log('Error while fething user profile data: $e');
    }
  }
}
