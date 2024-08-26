import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRepository{
  final  FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToCall() {
    return _firestore
        .collection('All Trips')
        .where('driverId', isEqualTo: "TTTRQy0nH7cAuIX9eeEr6akki8p2")
        .snapshots();
  }

   Future<void> completeRide(String docId, String newDriverId) async {
     try {
       await _firestore.collection('All Trips').doc(docId).update({
         'driverId': newDriverId+"dropped",
         'dropped': true,
       });
       print('Driver ID updated successfully');
     } catch (e) {
       print('Error updating Driver ID: $e');
     }
   }
   
  Future<void> updateTripState(String docId, String fieldName, bool value) async {
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