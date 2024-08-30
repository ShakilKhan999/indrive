import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indrive/utils/database_collection_names.dart';

import '../../../models/city_to_city_trip_model.dart';

class CityToCityTripRepository {
  Future<bool> addCityToCityRequest(
      CityToCityTripModel cityToCityTripModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityTrip)
          .doc(cityToCityTripModel.id)
          .set(cityToCityTripModel.toJson());
      return true;
    } catch (e) {
      log('Error while adding city to city trip: $e');
      return false;
    }
  }

  Stream<List<CityToCityTripModel>> getCityToCityTripList(
      {required String uid}) {
    return FirebaseFirestore.instance
        .collection(cityToCityTrip)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CityToCityTripModel.fromJson(doc.data()))
          .toList();
    });
  }
}
