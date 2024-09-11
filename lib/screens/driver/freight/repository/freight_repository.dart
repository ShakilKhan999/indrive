import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/driver_info_model.dart';
import '../../../../utils/database_collection_names.dart';

class FreightRepository {
  Future<bool> saveFreightInfo(
      {required DriverInfoModel driverInfoModel,
      required String uid,
      required String driverInfoDoc}) async {
    try {
      await FirebaseFirestore.instance
          .collection(freightCollection)
          .doc(uid)
          .set(driverInfoModel.toJson());
      return true;
    } catch (e) {
      log('Error while saving freight info data $e');
      return false;
    }
  }
}
