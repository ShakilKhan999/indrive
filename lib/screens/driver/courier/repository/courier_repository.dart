import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/driver_info_model.dart';
import '../../../../utils/database_collection_names.dart';

class CourierRepository {
  Future<bool> saveCourierInfo(
      {required DriverInfoModel driverInfoModel,
      required String uid,
      required String driverInfoDoc}) async {
    try {
      await FirebaseFirestore.instance

          .collection(courierCollection)
          .doc(uid)
          .set(driverInfoModel.toJson());
      return true;
    } catch (e) {
      log('Error while saving courier info data $e');
      return false;
    }
  }
}
