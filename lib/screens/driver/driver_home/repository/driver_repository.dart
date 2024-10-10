import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:callandgo/models/trip_model.dart';

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

  Future<void> AcceptTrip(String docId, String newDriverId, int rent) async {
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
      DocumentSnapshot tripDoc =
          await _firestore.collection('All Trips').doc(tripId).get();

      if (tripDoc.exists) {
        List<dynamic> bids = tripDoc.get('bids');

        int index = bids.indexWhere((bid) => bid['driverId'] == driverId);
        bids[index]["offerPrice"] = rent;
        bids[index]["bidStart"] = DateTime.now();

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

  Future<void> completeRoute(
      {required String tripId,
        required String encodedPoly}) async {
    try {
      DocumentSnapshot tripDoc =
      await _firestore.collection('All Trips').doc(tripId).get();

      if (tripDoc.exists) {
        List<dynamic> routes = tripDoc.get('routes');

        int index = routes.indexWhere((route) => route['encodedPolyline'] == encodedPoly);
        routes[index]["currentStatus"] = "Completed";

        await _firestore
            .collection('All Trips')
            .doc(tripId)
            .update({'routes': routes});

        print("route status update successfully from trip with ID: $tripId");
      } else {
        print("Trip document with ID $tripId does not exist.");
      }
    } catch (e) {
      print("Error removing bid: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToCall(String driverId) {
    return _firestore
        .collection('All Trips')
        .where('driverId', isEqualTo: driverId)
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

  Future<List<Trip>> getTripHistory(String driverId) async {
    try {
      CollectionReference<Map<String, dynamic>> tripsCollection = FirebaseFirestore.instance.collection('All Trips').withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (model, _) => model,
      );

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await tripsCollection.get();

      return querySnapshot.docs
          .where((doc) {
        final data = doc.data();
        String tripDriverId = data['driverId'];
        return tripDriverId == driverId ||
            tripDriverId == driverId + "dropped" ||
            tripDriverId == driverId + "cancelledbydriver";
      })
          .map((doc) => Trip.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }



  Future<void> cancelRide(String docId, String newDriverId) async {
    try {
      await _firestore.collection('All Trips').doc(docId).update({
        'driverId': newDriverId + " cancelledbydriver",
        'accepted': false,
        'driverCancel':true,
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
