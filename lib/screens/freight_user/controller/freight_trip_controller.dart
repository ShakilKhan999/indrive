import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:callandgo/main.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../helpers/color_helper.dart';
import '../../../helpers/method_helper.dart';
import '../../../models/freight_trip_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/app_config.dart';
import '../../../utils/database_collection_names.dart';
import '../../../utils/global_toast_service.dart';
import '../../auth_screen/controller/auth_controller.dart';
import '../repository/freight_trip_repository.dart';

class FreightTripController extends GetxController {
  var changingPickup = false.obs;
  var fromController = TextEditingController().obs;
  var toController = TextEditingController().obs;
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
  late GoogleMapController mapControllerForRide;
  late GoogleMapController mapControllerTO;
  var center = const LatLng(23.80, 90.41).obs;
  var isFreightTripCreationLoading = false.obs;
  var selectedButtonIndex = (-1).obs;
  var selectedDate = ''.obs;
  var selectedTripIndexForUser = 0.obs;
  var rideRoute = const LatLng(23.80, 90.41).obs;
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
  var findingRoutes = false.obs;
  var driverData = UserModel().obs;

  var selectedSize = 'Small'.obs;
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  void setSelectedSize(String? value) {
    if (value != null) {
      selectedSize.value = value;
    }
  }

  void selectButton(int index) async {
    selectedButtonIndex.value = index;
    if (index == 0) {
      selectedDate.value = 'time: 10-20 min';
    }
    if (index == 1) {
      selectedDate.value = 'time: up to 1 hour';
    }
    if (index == 2) {
      MethodHelper().hideKeyboard();
      DateTime? date = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (date != null) {
        selectedDate.value = 'date: ${date.toString()}';
      }
    }
  }

  void addPhoto(String imageLocationName) async {
    try {
      fToast.init(Get.context!);
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        photoPath.value = file.path;
        isPhotoLoading.value = true;
        photoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: imageLocationName))!;
        isPhotoLoading.value = false;
        log('Photo URL: ${photoUrl.value}');
      } else {
        showToast(toastText: 'No image selected', toastColor: ColorHelper.red);
      }
    } catch (e) {
      photoPath.value = '';
      isPhotoLoading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
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

  void onCameraIdle() {
    cameraMoving.value = false;
    log("camera Idle");
    getPlaceNameFromCoordinates(startPickedCenter.value.latitude,
        startPickedCenter.value.longitude, false);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getCenter(isFrom: true);
  }

  void onMapCreatedTo(GoogleMapController controller) {
    mapControllerTO = controller;
    getCenter(isFrom: false);
  }

  void onPressCreateRequest() async {
    try {
      fToast.init(Get.context!);
      isFreightTripCreationLoading.value = true;
      var uuid = Uuid();
      AuthController _authController = Get.find();
      FreightTripModel freightTripModel = FreightTripModel(
          id: uuid.v1(),
          from: fromPlaceName.value,
          to: toPlaceName.value,
          date: selectedDate.value.toString(),
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
          cargoImage: photoUrl.value,
          truckSize: selectedSize.value,
          createdAt: DateTime.now().toString());
      log('FreightTripModel: ${freightTripModel.toJson()}');

      bool response =
          await FreightTripRepository().addFreightRequest(freightTripModel);
      if (response) {
        isFreightTripCreationLoading.value = false;
        showToast(
            toastText: 'Request sent successfully',
            toastColor: ColorHelper.primaryColor);
        Get.back();
      } else {
        isFreightTripCreationLoading.value = false;
        showToast(
            toastText: 'Request sending failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      isFreightTripCreationLoading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
      log("Error while finding rider for city to city trip: $e");
    }
  }

  final RxList<FreightTripModel> tripList = <FreightTripModel>[].obs;
  var driverOfferYourFareController = <TextEditingController>[].obs;
  var selectedTripIndex = 0.obs;

  void getFreightTrips() {
    try {
      tripList.clear();
      FreightTripRepository()
          .getFreightTripList()
          .listen((List<FreightTripModel> trips) {
        MethodHelper().sortTripsByCreatedAt(trips);
        filterTrips(trips: trips);
      });
    } catch (e) {
      log("Error while getting city to city trips: $e");
    }
  }

  void filterTrips({required List<FreightTripModel> trips}) {
    List<FreightTripModel> filteredTrips = [];
    AuthController _authController = Get.find();
    for (var trip in trips) {
      if (trip.tripCurrentStatus == 'new' &&
          trip.userUid != _authController.currentUser.value.uid &&
          trip.declineDriverIds!
                  .contains(_authController.currentUser.value.uid!) ==
              false &&
          trip.truckSize ==
              _authController.currentUser.value.freightVehicleType) {
        filteredTrips.add(trip);
      }
    }
    tripList.assignAll(filteredTrips);
    driverOfferYourFareController.value = List.generate(
      filteredTrips.length,
      (index) => TextEditingController(),
    );

    assignTheDriverPricecallandgorOfferYourFareControllerIfExists();

    log('tripList: $tripList');
  }

  assignTheDriverPricecallandgorOfferYourFareControllerIfExists() {
    try {
      AuthController _authController = Get.find();
      for (var trip in tripList) {
        if (trip.bids!.isNotEmpty) {
          for (var bid in trip.bids!) {
            if (bid.driverUid == _authController.currentUser.value.uid) {
              driverOfferYourFareController[tripList.indexOf(trip)].text =
                  bid.driverPrice!;
            }
          }
        }
      }
    } catch (e) {
      log("Error while assigning driver price in driverOfferYourFareController: $e");
    }
  }

  sendDriverFareOffer() async {
    try {
      AuthController _authController = Get.find();

      if (checkUserAlreadyOfferedFare()) {
        Bids bids = Bids(
          driverUid: _authController.currentUser.value.uid,
          driverName: _authController.currentUser.value.name,
          driverImage: _authController.currentUser.value.photo,
          driverPhone: _authController.currentUser.value.phone,
          driverPrice:
              driverOfferYourFareController[selectedTripIndex.value].text,
          driverVehicle:
              _authController.currentUser.value.cityToCityVehicleType,
        );

        List<Bids> previousBids = removeBidsFromBidListByDriverUid(
            driverUid: _authController.currentUser.value.uid!);

        previousBids.add(bids);
        List<Map<String, dynamic>> newBids =
            previousBids.map((bid) => bid.toJson()).toList();
        var response = await FreightTripRepository()
            .updateBidsList(tripList[selectedTripIndex.value].id!, newBids);
        if (response) {
          showToast(
              toastText: 'Fare offer updated successfully',
              toastColor: ColorHelper.primaryColor);
        } else {
          showToast(
              toastText: 'Fare offer updating failed',
              toastColor: ColorHelper.red);
        }
      } else {
        Bids bids = Bids(
          driverUid: _authController.currentUser.value.uid,
          driverName: _authController.currentUser.value.name,
          driverImage: _authController.currentUser.value.photo,
          driverPhone: _authController.currentUser.value.phone,
          driverPrice:
              driverOfferYourFareController[selectedTripIndex.value].text,
          driverVehicle: null,
        );

        List<Bids> previousBids = tripList[selectedTripIndex.value].bids!;
        previousBids.add(bids);
        List<Map<String, dynamic>> newBids =
            previousBids.map((bid) => bid.toJson()).toList();

        var response = await FreightTripRepository()
            .updateBidsList(tripList[selectedTripIndex.value].id!, newBids);
        if (response) {
          showToast(
              toastText: 'Fare offer sent successfully',
              toastColor: ColorHelper.primaryColor);
        } else {
          showToast(
              toastText: 'Fare offer sending failed',
              toastColor: ColorHelper.red);
        }
      }
    } catch (e) {
      log("Error while sending driver fare offer: $e");
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  checkUserAlreadyOfferedFare() {
    bool isAlreadyOffered = false;
    AuthController _authController = Get.find();
    for (var bid in tripList[selectedTripIndex.value].bids!) {
      if (bid.driverUid == _authController.currentUser.value.uid) {
        isAlreadyOffered = true;
        break;
      }
    }
    return isAlreadyOffered;
  }

  List<Bids> removeBidsFromBidListByDriverUid({required String driverUid}) {
    List<Bids> bids = [];
    for (var bid in tripList[selectedTripIndex.value].bids!) {
      if (bid.driverUid != driverUid) {
        bids.add(bid);
      }
    }
    return bids;
  }

  final RxList<FreightTripModel> tripListForUser = <FreightTripModel>[].obs;
  void getFreightTripsForUser() {
    try {
      AuthController _authController = Get.find();
      tripListForUser.clear();
      FreightTripRepository()
          .getFreightTripListForUser(
              userId: _authController.currentUser.value.uid!)
          .listen((List<FreightTripModel> trips) {
        MethodHelper().sortTripsByCreatedAt(trips);
        tripListForUser.assignAll(trips);
        log('tripList: $tripListForUser');
      });
    } catch (e) {
      log("Error while getting city to city trips for user: $e");
    }
  }

  var selectedBidIndex = 0.obs;

  void acceptRideForUser() async {
    try {
      fToast.init(Get.context!);
      actionStarted.value = true;

      Map<String, dynamic> updateData = {
        'tripCurrentStatus': 'accepted',
        'isTripAccepted': true,
        'driverUid': tripListForUser[selectedTripIndexForUser.value]
            .bids![selectedBidIndex.value]
            .driverUid,
        'driverName': tripListForUser[selectedTripIndexForUser.value]
            .bids![selectedBidIndex.value]
            .driverName,
        'driverImage': tripListForUser[selectedTripIndexForUser.value]
            .bids![selectedBidIndex.value]
            .driverImage,
        'driverPhone': tripListForUser[selectedTripIndexForUser.value]
            .bids![selectedBidIndex.value]
            .driverPhone,
        'driverVehicle': tripListForUser[selectedTripIndexForUser.value]
            .bids![selectedBidIndex.value]
            .driverVehicle,
        'finalPrice': tripListForUser[selectedTripIndexForUser.value]
            .bids![selectedBidIndex.value]
            .driverPrice,
        'bids': [],
        'acceptBy': 'user',
      };
      bool result = await MethodHelper().updateDocFields(
          docId: tripListForUser[selectedTripIndexForUser.value].id!,
          fieldsToUpdate: updateData,
          collection: freightTripCollection);
      if (result) {
        actionStarted.value = false;
        Get.back();

        showToast(
            toastText: 'Ride accepted successfully',
            toastColor: ColorHelper.primaryColor);
      } else {
        actionStarted.value = false;
        Get.back();
        showToast(
            toastText: 'Ride accepting failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      actionStarted.value = false;
      Get.back();
      log("Error while accepting ride for user: $e");
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  final RxList<FreightTripModel> myTripListForUser = <FreightTripModel>[].obs;

  void getFreightMyTripsForUser() {
    try {
      AuthController _authController = Get.find();
      tripList.clear();
      FreightTripRepository()
          .getFreightMyTripListForUser(
              userId: _authController.currentUser.value.uid!)
          .listen((List<FreightTripModel> trips) {
        MethodHelper().sortTripsByCreatedAt(trips);
        myTripListForUser.assignAll(trips);
        log('my tripList: $tripListForUser');
      });
    } catch (e) {
      log("Error while getting city to city my trips for user: $e");
    }
  }

  String extractDate({required String date}) {
    if (date.contains('date')) {
      String stDate = date.replaceAll('date: ', '');
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(stDate));
    } else {
      return date.replaceAll('time: ', '');
    }
  }

  void declineBidForUser() async {
    try {
      fToast.init(Get.context!);
      actionStarted.value = true;
      List<Bids> bids = removeBidFromBidListForUser();
      List<Map<String, dynamic>> newBids =
          bids.map((bid) => bid.toJson()).toList();

      String declineUserUids = MethodHelper.joinStringsWithComma(
          tripListForUser[selectedTripIndexForUser.value].declineDriverIds!,
          tripListForUser[selectedTripIndexForUser.value]
              .bids![selectedBidIndex.value]
              .driverUid!);
      bool result = false;
      await FreightTripRepository()
          .updateBidsList(
              tripListForUser[selectedTripIndexForUser.value].id!, newBids)
          .then(
        (value) async {
          Map<String, dynamic> updateData = {
            'declineDriverIds': declineUserUids,
          };
          await MethodHelper().updateDocFields(
              docId: tripListForUser[selectedTripIndexForUser.value].id!,
              fieldsToUpdate: updateData,
              collection: freightTripCollection);
          result = true;
        },
      );

      if (result) {
        actionStarted.value = false;
        Get.back();
        showToast(
            toastText: 'Ride declined successfully',
            toastColor: ColorHelper.primaryColor);
      } else {
        actionStarted.value = false;
        Get.back();
        showToast(
            toastText: 'Ride declining failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      actionStarted.value = false;
      Get.back();
    }
  }

  List<Bids> removeBidFromBidListForUser() {
    List<Bids> bids = [];
    for (var bid in tripListForUser[selectedTripIndexForUser.value].bids!) {
      if (bid.driverUid !=
          tripListForUser[selectedTripIndexForUser.value]
              .bids![selectedBidIndex.value]
              .driverUid) {
        bids.add(bid);
      }
    }
    return bids;
  }

  void acceptRide() async {
    try {
      fToast.init(Get.context!);
      AuthController _authController = Get.find();
      Map<String, dynamic> updateData = {
        'tripCurrentStatus': 'accepted',
        'isTripAccepted': true,
        'driverUid': _authController.currentUser.value.uid!,
        'driverName': _authController.currentUser.value.name!,
        'driverImage': _authController.currentUser.value.photo ??
            'https://www.pngitem.com/pimgs/m/506-5067022_sweet-shap-profile-placeholder-hd-png-download.png',
        'driverPhone': _authController.currentUser.value.phone ?? '',
        'driverVehicle': _authController.currentUser.value.freightVehicleType,
        'finalPrice': tripList[selectedTripIndex.value].userPrice!,
        'bids': [],
        'acceptBy': 'rider',
      };
      bool result = await MethodHelper().updateDocFields(
          docId: tripList[selectedTripIndex.value].id!,
          fieldsToUpdate: updateData,
          collection: freightTripCollection);
      if (result) {
        showToast(
            toastText: 'Ride accepted successfully',
            toastColor: ColorHelper.primaryColor);
      } else {
        showToast(
            toastText: 'Ride accepting failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      log("Error while accepting ride: $e");
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  final RxList<FreightTripModel> myTripList = <FreightTripModel>[].obs;

  void getFreightMyTrips() {
    try {
      AuthController _authController = Get.find();
      tripList.clear();
      FreightTripRepository()
          .getFreightMyTripList(userId: _authController.currentUser.value.uid!)
          .listen((List<FreightTripModel> trips) {
        MethodHelper().sortTripsByCreatedAt(trips);
        myTripList.assignAll(trips);
        log('my tripList: $myTripList');
      });
    } catch (e) {
      log("Error while getting city to city my trips for user: $e");
    }
  }

  void declineRide() async {
    try {
      fToast.init(Get.context!);
      AuthController _authController = Get.find();
      List<Bids> bids = [];
      if (checkUserAlreadyOfferedFare()) {
        bids = removeBidFromBidList();
      } else {
        bids = tripList[selectedTripIndex.value].bids!;
      }

      List<Map<String, dynamic>> newBids =
          bids.map((bid) => bid.toJson()).toList();

      String declineUserUids = MethodHelper.joinStringsWithComma(
          tripList[selectedTripIndex.value].declineDriverIds!,
          _authController.currentUser.value.uid!);
      bool result = false;
      await FreightTripRepository()
          .updateBidsList(tripList[selectedTripIndex.value].id!, newBids)
          .then(
        (value) async {
          Map<String, dynamic> updateData = {
            'declineDriverIds': declineUserUids,
          };
          await MethodHelper().updateDocFields(
              docId: tripList[selectedTripIndex.value].id!,
              fieldsToUpdate: updateData,
              collection: freightTripCollection);
          result = true;
        },
      );

      if (result) {
        showToast(
            toastText: 'Ride declined successfully',
            toastColor: ColorHelper.primaryColor);
        Get.back();
      } else {
        showToast(
            toastText: 'Ride declining failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      log("Error while accepting ride: $e");
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  List<Bids> removeBidFromBidList() {
    List<Bids> bids = [];
    for (var bid in tripList[selectedTripIndex.value].bids!) {
      if (bid.driverUid !=
          tripList[selectedTripIndex.value]
              .bids![selectedBidIndex.value]
              .driverUid) {
        bids.add(bid);
      }
    }
    return bids;
  }

  cancelRideForUser({required String docId}) {
    try {
      MethodHelper().cancelRide(freightTripCollection, docId);
    } catch (e) {}
  }

  var actionStarted = false.obs;

  onPressPickup({required int index, bool fromDetails = false}) async {
    try {
      fToast.init(Get.context!);
      actionStarted.value = true;
      Map<String, dynamic> data = {
        'tripCurrentStatus': 'picked up',
      };
      bool result = await MethodHelper().updateDocFields(
          docId: myTripList[index].id!,
          fieldsToUpdate: data,
          collection: freightTripCollection);
      if (result) {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Picked up', toastColor: ColorHelper.primaryColor);
        if (fromDetails) {
          Get.back();
        }
      } else {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Failed', toastColor: ColorHelper.primaryColor);
      }
    } catch (e) {
      actionStarted.value = false;
      Get.back();
      showToast(
          toastText: 'Something went wrong',
          toastColor: ColorHelper.primaryColor);
    }
  }

  onPressDrop({required int index, bool fromDetails = false}) async {
    try {
      fToast.init(Get.context!);
      actionStarted.value = true;
      Map<String, dynamic> data = {
        'tripCurrentStatus': 'completed',
        'isTripCompleted': true,
      };
      bool result = await MethodHelper().updateDocFields(
          docId: myTripList[index].id!,
          fieldsToUpdate: data,
          collection: freightTripCollection);
      if (result) {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Droped', toastColor: ColorHelper.primaryColor);
        if (fromDetails) {
          Get.back();
        }
      } else {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Failed', toastColor: ColorHelper.primaryColor);
      }
    } catch (e) {
      actionStarted.value = false;
      Get.back();
      showToast(
          toastText: 'Something went wrong',
          toastColor: ColorHelper.primaryColor);
    }
  }

  onPressCancel({required int index, bool fromDetails = false}) async {
    try {
      fToast.init(Get.context!);
      actionStarted.value = true;
      Map<String, dynamic> data = {
        'tripCurrentStatus': 'cancelled',
        'isTripCancelled': true,
        'cancelBy': 'Rider',
        'cancelReason': 'Rider Canceled',
      };
      bool result = await MethodHelper().updateDocFields(
          docId: myTripList[index].id!,
          fieldsToUpdate: data,
          collection: freightTripCollection);
      if (result) {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Canceled', toastColor: ColorHelper.primaryColor);
        if (fromDetails) {
          Get.back();
        }
      } else {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Failed', toastColor: ColorHelper.primaryColor);
      }
    } catch (e) {
      actionStarted.value = false;
      Get.back();
      showToast(
          toastText: 'Something went wrong',
          toastColor: ColorHelper.primaryColor);
    }
  }

  onPressCancelForUser({required int index}) async {
    try {
      fToast.init(Get.context!);
      actionStarted.value = true;
      Map<String, dynamic> data = {
        'tripCurrentStatus': 'cancelled',
        'isTripCancelled': true,
        'cancelBy': 'User',
        'cancelReason': 'User Canceled',
      };
      bool result = await MethodHelper().updateDocFields(
          docId: myTripListForUser[index].id!,
          fieldsToUpdate: data,
          collection: freightTripCollection);
      if (result) {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Canceled', toastColor: ColorHelper.primaryColor);
      } else {
        actionStarted.value = false;
        Get.back();
        showToast(toastText: 'Failed', toastColor: ColorHelper.primaryColor);
      }
    } catch (e) {
      actionStarted.value = false;
      Get.back();
      showToast(
          toastText: 'Something went wrong',
          toastColor: ColorHelper.primaryColor);
    }
  }

  void onMapCreatedForRide(GoogleMapController controller) {
    mapControllerForRide = controller;
  }

  void onCameraMoveForRide(CameraPosition position) {
    log("camera Moving");
    rideRoute.value =
        LatLng(position.target.latitude, position.target.longitude);
    cameraMoving.value = true;
  }

  onPressItem({required FreightTripModel trip}) {
    onPressItemDetailsView(trip: trip);
    getPolyline(trip: trip);
    getDriverData(trip: trip);
  }

  onPressItemDetailsView({required FreightTripModel trip}) {
    rideRoute.value = LatLng(
      double.parse(trip.pickLatLng!.latitude.toString()),
      double.parse(trip.pickLatLng!.longitude.toString()),
    );
  }

  getDriverData({required FreightTripModel trip}) async {
    await MethodHelper().listerUserData(userId: trip.driverUid!).listen(
      (userData) {
        driverData.value = userData;
        loadMarkers(trip: trip);
      },
    );
  }

  getPolyline({required FreightTripModel trip}) async {
    polyLines = {};
    polylineCoordinates.value = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(trip.pickLatLng!.latitude, trip.pickLatLng!.longitude),
      PointLatLng(trip.dropLatLng!.latitude, trip.dropLatLng!.longitude),
      travelMode: TravelMode.driving,
    );
    log("polyLineResponse: ${result.points.length}");
    log("polylineCoordinates: ${polylineCoordinates.length}");
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log("${result.errorMessage}");
    }

    addPolyLine(
      polylineCoordinates
          .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
          .toList(),
    );
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polyLines[id] = polyline;
    // moveCameraToPolyline();
  }

  var allMarkers = <Marker>{}.obs;
  // Future<void> loadMarkers({required FreightTripModel trip}) async {
  //   allMarkers.clear();
  //   final BitmapDescriptor markerIconCar = await BitmapDescriptor.asset(
  //     const ImageConfiguration(size: Size(24, 24)),
  //     'assets/images/marker.png',
  //   );

  //   final BitmapDescriptor markerIconPickLocation =
  //       await BitmapDescriptor.asset(
  //     const ImageConfiguration(size: Size(24, 24)),
  //     'assets/images/pick_location.png',
  //   );
  //   final BitmapDescriptor markerIconDropLocation =
  //       await BitmapDescriptor.asset(
  //     const ImageConfiguration(size: Size(24, 24)),
  //     'assets/images/drop_location.png',
  //   );

  //   var locationList = [
  //     LatLng(driverData.value.latLng!.latitude,
  //         driverData.value.latLng!.longitude),
  //     LatLng(trip.pickLatLng!.latitude, trip.pickLatLng!.longitude),
  //     LatLng(trip.dropLatLng!.latitude, trip.dropLatLng!.longitude),
  //   ];

  //   Set<Marker> markers = locationList.asMap().entries.map((entry) {
  //     int idx = entry.key;
  //     LatLng location = entry.value;
  //     BitmapDescriptor icon;
  //     double angle = 0.0;
  //     if (idx == 0) {
  //       icon = markerIconCar;
  //       angle = driverData.value.vehicleAngle!;
  //     } else if (idx == 1) {
  //       icon = markerIconPickLocation;
  //     } else {
  //       icon = markerIconDropLocation;
  //     }

  //     return Marker(
  //       markerId: MarkerId(location.toString()),
  //       position: location,
  //       icon: icon,
  //       rotation: angle,
  //     );
  //   }).toSet();
  //   allMarkers.addAll(markers);
  //   log("markers len: ${allMarkers.length}");
  // }
  Future<void> loadMarkers({required FreightTripModel trip}) async {
    allMarkers.clear();
    await _loadMarker(trip, 0);
    await _loadMarker(trip, 1);
    await Future.delayed(Duration(milliseconds: AppConfig.markerTimeDelay));
    await _loadMarker(trip, 2);

    log("markers len: ${allMarkers.length}");
  }

  Future<void> _loadMarker(FreightTripModel trip, int index) async {
    final BitmapDescriptor icon;
    final LatLng location;
    double angle = 0.0;

    switch (index) {
      case 0:
        icon = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(24, 24)),
          'assets/images/drop_location.png',
        );
        location =
            LatLng(trip.dropLatLng!.latitude, trip.dropLatLng!.longitude);
        break;
      case 1:
        icon = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(24, 24)),
          'assets/images/pick_location.png',
        );
        location =
            LatLng(trip.pickLatLng!.latitude, trip.pickLatLng!.longitude);
        break;
      case 2:
        icon = await BitmapDescriptor.asset(
          ImageConfiguration(size: AppConfig.vehicleMarkerSize),
          'assets/images/marker.png',
        );
        location = LatLng(driverData.value.latLng!.latitude,
            driverData.value.latLng!.longitude);
        angle = driverData.value.vehicleAngle!;
        break;

      default:
        return;
    }

    allMarkers.add(Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      icon: icon,
      rotation: angle,
    ));
  }

  var suggestions = [].obs;
  void onSearchTextChanged(String query) async {
    if (query.isNotEmpty) {
      suggestions.clear();
      var response = await googlePlace.autocomplete.get(query);
      if (response != null) {
        AutocompletePrediction autocompletePrediction =
            response.predictions![0];
        log("placeDescription : ${autocompletePrediction.description}");
        var placeDetails = await googlePlace.details
            .get(autocompletePrediction.placeId.toString());
        log("LatLong: ${placeDetails!.result!.geometry!.location!.lat}");
        for (int i = 0; i < response.predictions!.length; i++) {
          suggestions.add({
            'placeId': response.predictions![i].placeId.toString(),
            'description': response.predictions![i].description.toString(),
          });
        }
      } else {
        log("Response is null");
      }
    }
  }

  getCenter({required bool isFrom}) async {
    LatLng userCentre = await MethodHelper().getUserLocation();
    center.value = userCentre;
    if (isFrom) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center.value,
          zoom: 15.0,
        ),
      ));
    }
  }
}
