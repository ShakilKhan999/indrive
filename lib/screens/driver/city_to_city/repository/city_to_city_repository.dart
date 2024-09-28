import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/driver_info_model.dart';
import '../../../../utils/database_collection_names.dart';

class CityToCityRepository {
  Future<bool> saveCityToCityInfo(
      {required DriverInfoModel driverInfoModel,
      required String uid,
      required String driverInfoDoc}) async {
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityCollection)
          .doc(uid)
          .set(driverInfoModel.toJson());
      return true;
    } catch (e) {
      log('Error while saving city to city info data $e');
      return false;
    }
  }


}
