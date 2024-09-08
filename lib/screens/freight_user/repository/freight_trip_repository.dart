import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indrive/models/freight_trip_model.dart';
import 'package:indrive/utils/database_collection_names.dart';

import '../../../models/city_to_city_trip_model.dart';

class FreightTripRepository {
  Future<bool> addFreightRequest(FreightTripModel freightTripModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(freightTripCollection)
          .doc(freightTripModel.id)
          .set(freightTripModel.toJson());
      return true;
    } catch (e) {
      log('Error while adding freight trip: $e');
      return false;
    }
  }

  Stream<List<FreightTripModel>> getFreightTripList() {
    return FirebaseFirestore.instance
        .collection(freightTripCollection)
        .where('tripCurrentStatus', isEqualTo: 'new')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FreightTripModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<FreightTripModel>> getFreightTripListForUser(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(freightTripCollection)
          .where('userUid', isEqualTo: userId)
          .where('tripCurrentStatus', isEqualTo: 'new')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => FreightTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }

  Future<bool> updateBidsList(
      String tripId, List<Map<String, dynamic>> newBids) async {
    try {
      await FirebaseFirestore.instance
          .collection(freightTripCollection)
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

  Stream<List<FreightTripModel>> getFreightMyTripListForUser(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(freightTripCollection)
          .where('userUid', isEqualTo: userId)
          .where('tripCurrentStatus', isEqualTo: 'accepted')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => FreightTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }

  Stream<List<FreightTripModel>> getFreightMyTripList(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(freightTripCollection)
          .where('driverUid', isEqualTo: userId)
          .where('tripCurrentStatus', isEqualTo: 'accepted')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => FreightTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }
}
