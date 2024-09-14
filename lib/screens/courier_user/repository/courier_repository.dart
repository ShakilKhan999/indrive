import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/courier_trip_model.dart';
import '../../../utils/database_collection_names.dart';

class CourierTripRepository {
  Future<bool> addCourierRequest(CourierTripModel courierTripModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(courierTripCollection)
          .doc(courierTripModel.id)
          .set(courierTripModel.toJson());
      return true;
    } catch (e) {
      log('Error while adding courier trip: $e');
      return false;
    }
  }
}
