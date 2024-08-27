import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityToCityRequestController extends GetxController {
  var fromController = TextEditingController().obs;
  var toController = TextEditingController().obs;
  var riderFareController = TextEditingController().obs;
  var parcelFareController = TextEditingController().obs;
  var parcelDescriptionController = TextEditingController().obs;
  var numberOfPassengers = Rx<int>(0);
  var selectedOptionIndex = 0.obs;
  var selectedDate = Rx<DateTime?>(null);

  var changingPickup = false.obs;
  var startPickedCenter = const LatLng(23.80, 90.41).obs;
  var cameraMoving = false.obs;
  var destinationPickedCenter = const LatLng(23.80, 90.41).obs;
  var fromPlaceName = "".obs;
  var toPlaceName = "".obs;
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  var center = const LatLng(23.80, 90.41).obs;

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  void onCameraMove(CameraPosition position) {
    log("camera Moving");
    startPickedCenter.value =
        LatLng(position.target.latitude, position.target.longitude);
    cameraMoving.value = true;
  }

  void onCameraMoveTo(CameraPosition position) {
    log("camera Moving To destination");
    destinationPickedCenter.value =
        LatLng(position.target.latitude, position.target.longitude);
  }

  void onCameraIdleTo() {
    log("camera Idle to destination");
    getPlaceNameFromCoordinates(destinationPickedCenter.value.latitude,
        destinationPickedCenter.value.longitude, true);
  }

  void onCameraIdle() {
    cameraMoving.value = false;
    log("camera Idle");
    getPlaceNameFromCoordinates(startPickedCenter.value.latitude,
        startPickedCenter.value.longitude, false);
  }

  Future<void> getPlaceNameFromCoordinates(
      double latitude, double longitude, bool destination) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if (destination) {
          toPlaceName.value =
              '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
          toController.value.text = toPlaceName.value;
        } else {
          fromPlaceName.value =
              '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
          fromController.value.text = fromPlaceName.value;
        }
      } else {
        log("Unknown place");
      }
    } catch (e) {
      log("Error getting place name: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapCreatedTo(GoogleMapController controller) {
    mapControllerTO = controller;
  }
}
