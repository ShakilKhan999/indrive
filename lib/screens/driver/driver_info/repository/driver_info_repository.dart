import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/driver_info_model.dart';
import '../../../../utils/database_collection_names.dart';

class DriverInfoRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<bool> saveDriverInfoData(
      {required DriverInfoModel driverInfoModel,
      required String uid,
      required String driverInfoDoc}) async {
    try {
      await _db
          .collection(userCollection)
          .doc(uid)
          .collection(driverDetialsCollection)
          .doc(driverInfoDoc)
          .set(driverInfoModel.toJson());

      return true;
    } catch (e) {
      log('Error while saving driver info data $e');
      return false;
    }
  }

  Future<void> updateUserFields(
      String userId, Map<String, dynamic> fieldsToUpdate) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection(userCollection);
      await users.doc(userId).update(fieldsToUpdate);
      log('User fields updated successfully');
    } catch (e) {
      log('Error updating user fields: $e');
    }
  }
}
