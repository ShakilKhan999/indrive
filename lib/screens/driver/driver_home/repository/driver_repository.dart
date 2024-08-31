import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indrive/models/trip_model.dart';

class DriverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Trip>> getTripsByDriverId(String driverId) {
    return _firestore.collection('All Trips').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            Trip trip = Trip.fromJson(doc.data());
            bool hasMatchingDriverId =
                trip.bids!.any((bid) => bid.driverId == driverId);
            return hasMatchingDriverId ? trip : null;
          })
          .where((trip) => trip != null) // Filter out null trips
          .cast<Trip>() // Cast to List<TripModel> to ensure type safety
          .toList();
    });
  }

  Future<void> AcceptTrip(String docId, String newDriverId, double rent) async {
    try {
      await _firestore.collection('All Trips').doc(docId).update({
        'driverId': newDriverId,
        'accepted': true,
        'rent': rent,
        'bids': []
      });
      print('Driver ID updated successfully');
    } catch (e) {
      print('Error updating Driver ID: $e');
    }
  }

  Future<void> offerRent(
      {required String tripId,
      required String driverId,
      required double rent}) async {
    try {
      // Step 1: Retrieve the document
      DocumentSnapshot tripDoc =
          await _firestore.collection('All Trips').doc(tripId).get();

      if (tripDoc.exists) {
        // Step 2: Extract the list of bids from the document
        List<dynamic> bids = tripDoc.get('bids');

        // Step 3: Filter out the bid with the matching driverId
        int index = bids.indexWhere((bid) => bid['driverId'] == driverId);
        bids[index]["offerPrice"] = rent;
        bids[index]["bidStart"] = DateTime.now();

        // Step 4: Update the document with the modified list
        await _firestore
            .collection('All Trips')
            .doc(tripId)
            .update({'bids': bids});

        print("Bid removed successfully from trip with ID: $tripId");
      } else {
        print("Trip document with ID $tripId does not exist.");
      }
    } catch (e) {
      print("Error removing bid: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToCall() {
    return _firestore
        .collection('All Trips')
        .where('driverId', isEqualTo: "I54BCk2Qa3NNMpVMytnMofUiSzy1")
        .snapshots();
  }

  Future<void> completeRide(String docId, String newDriverId) async {
    try {
      await _firestore.collection('All Trips').doc(docId).update({
        'driverId': newDriverId + "dropped",
        'dropped': true,
      });
      print('Driver ID updated successfully');
    } catch (e) {
      print('Error updating Driver ID: $e');
    }
  }

  Future<void> updateTripState(
      String docId, String fieldName, bool value) async {
    try {
      await _firestore.collection('All Trips').doc(docId).update({
        fieldName: value,
      });
      print('trip state updated successfully');
    } catch (e) {
      print('Error updating Trip State: $e');
    }
  }
}
