import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../helpers/color_helper.dart';
import '../../../helpers/method_helper.dart';
import '../../../main.dart';
import '../../../models/courier_trip_model.dart';
import '../../../utils/global_toast_service.dart';
import '../../auth_screen/controller/auth_controller.dart';
import '../repository/courier_repository.dart';

class CourierTripController extends GetxController {
  var pickUpController = TextEditingController().obs;
  var destinationController = TextEditingController().obs;
  var fareCourierController = TextEditingController().obs;
  var isMotorcycleSelected = true.obs;
  var isOptionButtonEnabled = true.obs;

  //oder deatils----------------------->>>>>
  var pickUpStreetInfoController = TextEditingController().obs;
  var pickUpFloorInfoController = TextEditingController().obs;
  var pickUpSenderPhoneInfoController = TextEditingController().obs;

  var deliveryStreetInfoController = TextEditingController().obs;
  var deliveryFloorInfoController = TextEditingController().obs;
  var recipientPhoneController = TextEditingController().obs;

  var descriptionDeliverController = TextEditingController().obs;

  var changingPickup = false.obs;
  var offerFareController = TextEditingController().obs;
  var photoPath = ''.obs;
  var isPhotoLoading = false.obs;
  var photoUrl = ''.obs;
  var startPickedCenter = const LatLng(23.80, 90.41).obs;
  var cameraMoving = false.obs;
  var destinationPickedCenter = const LatLng(23.80, 90.41).obs;
  var fromPlaceName = "".obs;
  var toPlaceName = "".obs;
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  var center = const LatLng(23.80, 90.41).obs;
  var isCourierTripCreationLoading = false.obs;

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
          destinationController.value.text = toPlaceName.value;
        } else {
          fromPlaceName.value = location;
          pickUpController.value.text = fromPlaceName.value;
        }
      } else {
        log("Unknown place");
      }
    } catch (e) {
      log("Error getting place name: $e");
    }
  }

  void onCameraIdle() {
    cameraMoving.value = false;
    log("camera Idle");
    getPlaceNameFromCoordinates(startPickedCenter.value.latitude,
        startPickedCenter.value.longitude, false);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapCreatedTo(GoogleMapController controller) {
    mapControllerTO = controller;
  }

  void onPressCreateRequest() async {
    try {
      fToast.init(Get.context!);
      isCourierTripCreationLoading.value = true;
      var uuid = Uuid();
      AuthController _authController = Get.find();
      CourierTripModel freightTripModel = CourierTripModel(
        id: uuid.v1(),
        from: fromPlaceName.value,
        to: toPlaceName.value,
        userPrice: offerFareController.value.text,
        userPhone: _authController.currentUser.value.phone,
        userName: _authController.currentUser.value.name,
        userImage: _authController.currentUser.value.photo,
        userUid: _authController.currentUser.value.uid,
        isTripAccepted: false,
        isTripCancelled: false,
        isTripCompleted: false,
        tripCurrentStatus: "new",
        pickLatLng: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        dropLatLng: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude),
        bids: [],
        declineDriverIds: '',
        createdAt: DateTime.now().toString(),
        isDoorToDoor: isOptionButtonEnabled.value,
        senderPhone: pickUpSenderPhoneInfoController.value.text,
        pickupFullAddress: pickUpStreetInfoController.value.text,
        pickupHomeAddress: pickUpFloorInfoController.value.text,
        recipientPhone: recipientPhoneController.value.text,
        destinationFullAddress: deliveryStreetInfoController.value.text,
        destinationHomeAddress: deliveryFloorInfoController.value.text,
        
      );
      log('CourierTripModel: ${freightTripModel.toJson()}');

      bool response =
          await CourierTripRepository().addCourierRequest(freightTripModel);
      if (response) {
        isCourierTripCreationLoading.value = false;
        showToast(
            toastText: 'Request sent successfully',
            toastColor: ColorHelper.primaryColor);
        Get.back();
      } else {
        isCourierTripCreationLoading.value = false;
        showToast(
            toastText: 'Request sending failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      isCourierTripCreationLoading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
      log("Error while finding rider for city to city trip: $e");
    }
  }
}
