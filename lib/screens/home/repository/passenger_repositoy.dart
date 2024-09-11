import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/trip_model.dart';

class PassengerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> listenToDriverDocs() {
    return _firestore
        .collection('users')
        .where('isDriverMode', isEqualTo: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToCalledTrip(
      String docId) {
    return _firestore.collection('All Trips').doc(docId).snapshots();
  }

  Future<void> callDriver(String docId, String newDriverId, int rent) async {
    try {
      await _firestore
          .collection('All Trips')
          .doc(docId)
          .update({'driverId': newDriverId, 'rent': rent, 'bids': []});
      print('Driver ID updated successfully');
    } catch (e) {
      print('Error updating Driver ID: $e');
    }
  }

  Future<void> removeBidByDriverId({
    required String tripId,
    required String driverId,
  }) async {
    try {
      // Step 1: Retrieve the document
      DocumentSnapshot tripDoc =
          await _firestore.collection('All Trips').doc(tripId).get();

      if (tripDoc.exists) {
        // Step 2: Extract the list of bids from the document
        List<dynamic> bids = tripDoc.get('bids');

        // Step 3: Filter out the bid with the matching driverId
        bids.removeWhere((bid) => bid['driverId'] == driverId);

        // Step 4: Update the document with the modified list
        await _firestore.collection('All Trips').doc(tripId).update({
          'bids': bids,
        });

        print("Bid removed successfully from trip with ID: $tripId");
      } else {
        print("Trip document with ID $tripId does not exist.");
      }
    } catch (e) {
      print("Error removing bid: $e");
    }
  }

  Future<void> addNewTrip(Trip trip) async {
    try {
      Map<String, dynamic> tripData = trip.toJson();
      await _firestore.collection('All Trips').doc(trip.tripId).set(tripData);
      log('Trip added successfully with ID: ${trip.tripId}');
    } catch (e) {
      log('Error adding trip: $e');
    }
  }
}
