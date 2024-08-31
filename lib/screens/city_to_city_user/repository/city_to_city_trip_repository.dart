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

  Future<bool> updateBidsList(
      String tripId, List<Map<String, dynamic>> newBids) async {
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityTrip)
          .doc(tripId)
          .update({'bids': newBids});
      log('Bids list updated successfully');
      return true;
    } catch (e) {
      log('Error updating bids list: $e');
      return false;
    }
  }

  UpdateFareDriverFareOffer(String tripId, String driverUid,) async{
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityTrip)
          .doc(tripId)
          .update({'driverUid': driverUid});
      log('Bids list updated successfully');
      return true;
    } catch (e) {
      log('Error updating bids list: $e');
      return false;
    }
  }

}
