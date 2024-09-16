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

  Stream<List<CourierTripModel>> getCourierTripListForUser(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(courierTripCollection)
          .where('userUid', isEqualTo: userId)
          .where('tripCurrentStatus', isEqualTo: 'new')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CourierTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }

  Stream<List<CourierTripModel>> getCourierTripList() {
    return FirebaseFirestore.instance
        .collection(courierTripCollection)
        .where('tripCurrentStatus', isEqualTo: 'new')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CourierTripModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<CourierTripModel>> getCourierMyTripList(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(courierTripCollection)
          .where('driverUid', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CourierTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }

  Future<bool> updateBidsList(
      String tripId, List<Map<String, dynamic>> newBids) async {
    try {
      await FirebaseFirestore.instance
          .collection(courierTripCollection)
          .doc(tripId)
          .update({'bids': newBids});
      log('Bids list updated successfully');
      return true;
    } catch (e) {
      log('Error updating bids list: $e');
      return false;
    }
  }

  Stream<List<CourierTripModel>> getCourierMyTripListForUser(
      {required String userId}) {
    {
      return FirebaseFirestore.instance
          .collection(courierTripCollection)
          .where('userUid', isEqualTo: userId)
          .where('isTripAccepted', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CourierTripModel.fromJson(doc.data()))
            .toList();
      });
    }
  }
}
