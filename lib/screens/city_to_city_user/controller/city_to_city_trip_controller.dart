import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/helpers/method_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/models/city_to_city_trip_model.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/city_to_city_user/repository/city_to_city_trip_repository.dart';
import 'package:indrive/screens/driver/city_to_city/repository/city_to_city_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../helpers/color_helper.dart';
import '../../../utils/global_toast_service.dart';

class CityToCityTripController extends GetxController {
  var fromController = TextEditingController().obs;
  var toController = TextEditingController().obs;
  var riderFareController = TextEditingController().obs;
  var parcelFareController = TextEditingController().obs;
  var parcelDescriptionController = TextEditingController().obs;
  var addDescriptionController = TextEditingController().obs;
  var numberOfPassengers = Rx<int>(0);
  var selectedOptionIndex = 0.obs;
  var selectedDate = Rx<DateTime?>(null);
  var tripType = "ride".obs;
  var isCityToCityTripCreationLoading = false.obs;

  var changingPickup = false.obs;
  var startPickedCenter = const LatLng(23.80, 90.41).obs;
  var cameraMoving = false.obs;
  var destinationPickedCenter = const LatLng(23.80, 90.41).obs;
  var fromPlaceName = "".obs;
  var toPlaceName = "".obs;
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  var center = const LatLng(23.80, 90.41).obs;
  final RxList<CityToCityTripModel> tripList = <CityToCityTripModel>[].obs;

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
        String location =
            MethodHelper().getLocationFromLatLng(placemarks: placemarks);

        if (destination) {
          toPlaceName.value = location;
          toController.value.text = toPlaceName.value;
        } else {
          fromPlaceName.value = location;
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

  void onPressFindRider() async {
    try {
      fToast.init(Get.context!);
      isCityToCityTripCreationLoading.value = true;
      var uuid = Uuid();
      AuthController _authController = Get.find();
      CityToCityTripModel cityToCityTripModel = CityToCityTripModel(
        id: uuid.v1(),
        cityFrom: fromPlaceName.value,
        cityTo: toPlaceName.value,
        date: selectedDate.value.toString(),
        userPrice: tripType.value == 'ride'
            ? riderFareController.value.text
            : parcelFareController.value.text,
        numberOfPassengers:
            tripType.value == 'ride' ? numberOfPassengers.value : null,
        userPhone: _authController.currentUser.value.phone,
        userName: _authController.currentUser.value.name,
        userImage: _authController.currentUser.value.photo,
        userUid: _authController.currentUser.value.uid,
        isTripAccepted: false,
        isTripCancelled: false,
        isTripCompleted: false,
        tripCurrentStatus: "new",
        tripType: tripType.value,
        pickLatLng: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        dropLatLng: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude),
        bids: [],
        description: addDescriptionController.value.text,
      );

      bool response = await CityToCityTripRepository()
          .addCityToCityRequest(cityToCityTripModel);
      if (response) {
        isCityToCityTripCreationLoading.value = false;
        showToast(
            toastText: 'Request sent successfully',
            toastColor: ColorHelper.primaryColor);
        Get.back();
      } else {
        isCityToCityTripCreationLoading.value = false;
        showToast(
            toastText: 'Request sending failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      isCityToCityTripCreationLoading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
      log("Error while finding rider for city to city trip: $e");
    }
  }

  void fetchCityToCityTrips() {
    AuthController _authController = Get.find();
    CityToCityTripRepository()
        .getCityToCityTripList(uid: _authController.currentUser.value.uid!)
        .listen((List<CityToCityTripModel> trips) {
      filterTrips(trips: trips);
    });
  }

  void filterTrips({required List<CityToCityTripModel> trips}) {
    List<CityToCityTripModel> filteredTrips = [];
    AuthController _authController = Get.find();
    for (var trip in trips) {
      if (trip.tripCurrentStatus == 'new' &&
          trip.userUid != _authController.currentUser.value.uid) {
        filteredTrips.add(trip);
      }
    }
    tripList.assignAll(filteredTrips);
    log('tripList: $tripList');
  }
}
