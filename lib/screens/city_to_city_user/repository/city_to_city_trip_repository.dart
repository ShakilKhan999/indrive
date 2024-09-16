import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:callandgo/utils/database_collection_names.dart';

import '../../../models/city_to_city_trip_model.dart';

class CityToCityTripRepository {
  Future<bool> addCityToCityRequest(
      CityToCityTripModel cityToCityTripModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityTripCollection)
          .doc(cityToCityTripModel.id)
          .set(cityToCityTripModel.toJson());
      return true;
    } catch (e) {
      log('Error while adding city to city trip: $e');
      return false;
    }
  }

  Stream<List<CityToCityTripModel>> getCityToCityTripList() {
    return FirebaseFirestore.instance
        .collection(cityToCityTripCollection)
        .where('tripCurrentStatus', isEqualTo: 'new')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CityToCityTripModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<CityToCityTripModel>> getCityToCityTripListForUser(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(cityToCityTripCollection)
          .where('userUid', isEqualTo: userId)
          .where('tripCurrentStatus', isEqualTo: 'new')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CityToCityTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }

  Future<bool> updateBidsList(
      String tripId, List<Map<String, dynamic>> newBids) async {
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityTripCollection)
          .doc(tripId)
          .update({'bids': newBids});
      log('Bids list updated successfully');
      return true;
    } catch (e) {
      log('Error updating bids list: $e');
      return false;
    }
  }

  UpdateFareDriverFareOffer(
    String tripId,
    String driverUid,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(cityToCityTripCollection)
          .doc(tripId)
          .update({'driverUid': driverUid});
      log('Bids list updated successfully');
      return true;
    } catch (e) {
      log('Error updating bids list: $e');
      return false;
    }
  }

  Stream<List<CityToCityTripModel>> getCityToCityMyTripListForUser(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(cityToCityTripCollection)
          .where('userUid', isEqualTo: userId)
          .where('isTripAccepted', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CityToCityTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }

  Stream<List<CityToCityTripModel>> getCityToCityMyTripList(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(cityToCityTripCollection)
          .where('driverUid', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CityToCityTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }
}
