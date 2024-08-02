import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/trip_model.dart';

class PassengerRepository{
   final  FirebaseFirestore _firestore=FirebaseFirestore.instance;
   Stream<QuerySnapshot<Map<String, dynamic>>> listenToDriverDocs() {
    return _firestore
        .collection('users')
        .where('isDriver', isEqualTo: true)
        .snapshots();
  }

   Stream<DocumentSnapshot<Map<String, dynamic>>> listenToCalledTrip(String docId) {
     return _firestore
         .collection('All Trips')
         .doc(docId)
         .snapshots();
   }

   Future<void> callDriver(String docId, String newDriverId) async {
     try {
       await _firestore.collection('All Trips').doc(docId).update({
         'driverId': newDriverId,
       });
       print('Driver ID updated successfully');
     } catch (e) {
       print('Error updating Driver ID: $e');
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