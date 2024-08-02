import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:indrive/models/trip_model.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/home/repository/passenger_repositoy.dart';
import 'package:indrive/utils/app_config.dart';
import 'package:uuid/uuid.dart';

import '../../../models/user_model.dart';

class HomeController extends GetxController {
  var selectedVehicle = "car".obs;
  var userLat = 0.0.obs;
  var userLong = 0.0.obs;
  var cameraMoving = false.obs;
  var pickingDestination = false.obs;
  var suggestedPlaces = [].obs;

  var driverList = [].obs;
  var driverMarkerList = [].obs;

  var myPlaceName = "Searching for you on the map..".obs;
  var destinationPlaceName = "".obs;
  var center = const LatLng(23.80, 90.41).obs;
  var lastPickedCenter = const LatLng(23.80, 90.41).obs;
  var destinationPickedCenter = const LatLng(23.80, 90.41).obs;
  var startPickedCenter = const LatLng(23.80, 90.41).obs;
  var currentUser = UserModel().obs;
  var emailController = TextEditingController().obs;
  var fullNameController = TextEditingController().obs;
  var selectedLocation = 'Dhaka (ঢাকা)'.obs;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  getUserData() async {
    try {
      AuthController authController = Get.find();
      currentUser.value = (await authController.getCurrentUser())!;
      fullNameController.value.text = currentUser.value.name!;
      emailController.value.text = currentUser.value.email!;
    } catch (e) {
      log('Error while fethching user data: $e');
    }
  }

  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;

  getPolyline() async {
    polyLines.clear();
    polylineCoordinates.clear;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(
          startPickedCenter.value.latitude, startPickedCenter.value.longitude),
      PointLatLng(destinationPickedCenter.value.latitude,
          destinationPickedCenter.value.longitude),
      travelMode: TravelMode.driving,
    );
    log("polyLineResponse: ${result.points.length}");
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log("${result.errorMessage}");
    }

    addPolyLine(
      polylineCoordinates.value
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
    moveCameraToPolyline();
  }

  void moveCameraToPolyline() {
    if (polylineCoordinates.isEmpty) return;

    double minLat = polylineCoordinates[0].latitude;
    double maxLat = polylineCoordinates[0].latitude;
    double minLng = polylineCoordinates[0].longitude;
    double maxLng = polylineCoordinates[0].longitude;

    for (var point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  final TextEditingController destinationController = TextEditingController();
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraMove(CameraPosition position) {
    log("camera Moving");
    lastPickedCenter.value =
        LatLng(position.target.latitude, position.target.longitude);
    if (pickingDestination.value) {
      destinationPickedCenter.value =
          LatLng(position.target.latitude, position.target.longitude);
    } else {
      startPickedCenter.value =
          LatLng(position.target.latitude, position.target.longitude);
    }
    cameraMoving.value = true;
  }

  void onCameraIdle() {
    log("camera Idle");
    getPlaceNameFromCoordinates(
        lastPickedCenter.value.latitude, lastPickedCenter.value.longitude);
    cameraMoving.value = false;
  }

  Future<Position> getCurrentLocation() async {
    log("getCurrentLocation called");
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position.
    return await Geolocator.getCurrentPosition();
  }

  var userLocationPicking = false.obs;
  void getUserLocation() async {
    userLocationPicking.value = true;
    log("getUserLocation called");
    try {
      Position position = await getCurrentLocation();
      userLat.value = position.latitude;
      userLong.value = position.longitude;
      log("user long ${userLong.value}");
      center.value = LatLng(userLat.value, userLong.value);
      mapController.animateCamera(
        CameraUpdate.newLatLng(center.value),
      );
      getPlaceNameFromCoordinates(userLat.value, userLong.value);
      userLocationPicking.value = false;
    } catch (e) {
      userLocationPicking.value = false;
      log('Failed to get location: $e');
    }
  }

  Future<void> getPlaceNameFromCoordinates(
      double latitude, double longitude) async {
    myPlaceName.value = "Searching for you on the map..";
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if (pickingDestination.value) {
          destinationPlaceName.value =
              '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
          destinationController.text = destinationPlaceName.value;
          getPolyline();
        } else {
          myPlaceName.value =
              '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
        }

        log("myPlaceName: ${myPlaceName.value}");
      } else {
        log("Unknown place");
      }
    } catch (e) {
      log("Error getting place name: $e");
    }
  }

  String generateUniqueId({int length = 10}) {
    var uuid = Uuid();
    String fullUuid = uuid.v4().replaceAll('-', '');
    return fullUuid.substring(0, length);
  }

  Future<void> getDriverList() async {
    PassengerRepository().listenToDriverDocs().listen((event) {
      driverList.value = List.generate(
          event.docs.length,
          (index) => UserModel.fromJson(
              event.docs[index].data() as Map<String, dynamic>));

      driverMarkerList.value = driverList
          .where((driver) => driver.latLng != null)
          .map((driver) =>
              LatLng(driver.latLng.latitude, driver.latLng.longitude))
          .toList();
    });
  }

  var calledTrip = [].obs;
  Future<void> listenCalledTrip(String docId) async {
    final subscription =
        PassengerRepository().listenToCalledTrip(docId).listen((snapshot) {
      if (snapshot.exists) {
        calledTrip.add(Trip.fromJson(snapshot.data() as Map<String, dynamic>));
        print("jksdfmsdn:${calledTrip[0].destination}");
      } else {
        print('Document does not exist');
      }
    });

    // Wait for the first snapshot
    await subscription.asFuture<void>();
    // Cancel the subscription to prevent further updates
    await subscription.cancel();
  }

  var tripCalled = false.obs;
  Future<void> callTrip() async {
    tripCalled.value = true;
    String tripId = generateUniqueId();
    Trip trip = Trip(
        userId: "8mCWZ9uBrWME2Bfm9YOCvb0U2EJ3",
        driverId: "",
        destination: destinationController.text,
        pickLatLng: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        dropLatLng: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude),
        tripId: tripId,
        driverCancel: false,
        userCancel: false,
        accepted: false,
        picked: false,
        dropped: false);
    await PassengerRepository().addNewTrip(trip);

    listenCalledTrip(tripId);

    await Future.delayed(Duration(seconds: 3));

    for (int i = 0; i < driverList.length; i++) {
      print("nsdnnsdnmf,sd,mf,msd,mf,ms,dm");
      if (driverList[i].latLng != null &&
          calledTrip[0].accepted == false &&
          calledTrip[0].driverCancel == false) {
        await PassengerRepository().callDriver(tripId, driverList[i].uid);
        mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
            driverList[i].latLng.latitude, driverList[i].latLng.longitude)));
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }
}
