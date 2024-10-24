import 'dart:convert';
import 'dart:developer';

import 'package:callandgo/utils/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../models/trip_model.dart';
import '../../../models/trip_review_model.dart';

class PassengerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> listenToDriverDocs() {
    return _firestore
        .collection('users')
        .where('isDriverMode', isEqualTo: true)
        .snapshots();
  }


  Future<List<Trip>> getTripHistory(String userId) async {
    try {
      CollectionReference<Map<String, dynamic>> tripsCollection = FirebaseFirestore.instance.collection('All Trips').withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (model, _) => model,
      );

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await tripsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return Trip.fromJson(doc.data()); // Use the fromJson method here
      }).toList();
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

  Future<String> getPolylineFromGoogleMap(LatLng start, LatLng end) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    final String url =
        '$baseUrl?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=${AppConfig.mapApiKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        // Get the polyline from the routes
        final polyline = data['routes'][0]['overview_polyline']['points'];
        return polyline;
      } else {
        throw Exception('Failed to get directions: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load directions');
    }
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

  Future<void> cancelRide(String docId, String newDriverId) async {
    try {
      await _firestore.collection('All Trips').doc(docId).update({
        'driverId':"",
        'userCancel': true,
      });
      print('Driver ID updated successfully');
    } catch (e) {
      print('Error updating Driver ID: $e');
    }
  }


  Future<void> addTripReview({
    required String userId,
    required TripReview tripReview,
  }) async {
    try {
      CollectionReference reviewsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Reviews');

      await reviewsCollection.add(tripReview.toJson());
      print('Review added successfully!');
    } catch (e) {
      print('Error adding review: $e');
    }
  }

  Future<void> removeThisTrip( String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("All Trips")
          .doc(docId)
          .delete();
      print("Document with ID $docId deleted successfully.");
    } catch (e) {
      print("Error deleting document: $e");
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
