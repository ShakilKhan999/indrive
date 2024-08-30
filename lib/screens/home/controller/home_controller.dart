import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:indrive/models/trip_model.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/auth_screen/repository/auth_repository.dart';
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
  var tempDriverMarkerList = [].obs;

  var myPlaceName = "Searching for you on the map..".obs;
  var destinationPlaceName = "".obs;
  var minOfferPrice = 0.obs;
  var center = const LatLng(23.80, 90.41).obs;
  var lastPickedCenter = const LatLng(23.80, 90.41).obs;
  var destinationPickedCenter = const LatLng(23.80, 90.41).obs;
  var startPickedCenter = const LatLng(23.80, 90.41).obs;

  @override
  void onInit() {
    AuthController authController = Get.put(AuthController());
    authController.getUserData();
    getDriverList();
    super.onInit();
  }

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
  var findingRoutes = false.obs;
  getPolyline() async {
    findingRoutes.value = true;
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
      polylineCoordinates
          .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
          .toList(),
    );
    findingRoutes.value = false;
    minOfferPrice.value = calculateRentPrice(
        point1: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        point2: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude));

    offerPriceController.text = minOfferPrice.value.toString();
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

  var allMarkers = <Marker>{}.obs;

  final List<double> _rotations = [
    0.0,
    45.0,
    90.0,
  ];

  var cardriverMarkerList = [].obs;
  var motodriverMarkerList = [].obs;
  var cngdriverMarkerList = [].obs;

  Future<void> loadMarkers() async {
    await Future.delayed(const Duration(seconds: 1));
    final BitmapDescriptor markerIconCar =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/marker.png',
    );
    final BitmapDescriptor markerIconMoto =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/cngMarker.png',
    );
    final BitmapDescriptor markerIconCng =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/cngMarker.png',
    );
    var carListToMarked = cardriverMarkerList;
    var motoListToMarked = motodriverMarkerList;
    var cngListToMarked = cngdriverMarkerList;

    if (selectedVehicle.value == "car") {
      Set<Marker> markers = carListToMarked.value.asMap().entries.map((entry) {
        int idx = entry.key;
        LatLng location = entry.value;
        double rotation =
            _rotations[idx % _rotations.length]; // Cycle through rotations

        return Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: markerIconCar,
          rotation: rotation,
        );
      }).toSet();

      allMarkers.value = markers;
      log("car marker length: ${allMarkers.length}");
    } else if (selectedVehicle.value == "moto") {
      Set<Marker> markers = motoListToMarked.value.asMap().entries.map((entry) {
        int idx = entry.key;
        LatLng location = entry.value;
        double rotation =
            _rotations[idx % _rotations.length]; // Cycle through rotations

        return Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: markerIconMoto,
          rotation: rotation,
        );
      }).toSet();

      allMarkers.value = markers;
      log("moto marker length: ${allMarkers.length}");
    } else if (selectedVehicle.value == "cng") {
      Set<Marker> markers = cngListToMarked.value.asMap().entries.map((entry) {
        int idx = entry.key;
        LatLng location = entry.value;
        double rotation =
            _rotations[idx % _rotations.length]; // Cycle through rotations

        return Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: markerIconCng,
          rotation: rotation,
        );
      }).toSet();

      allMarkers.value = markers;
      log("cng marker length: ${allMarkers.length}");
    }
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

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  var changingPickup = false.obs;
  void onMapCreatedTo(GoogleMapController controller) {
    mapControllerTO = controller;
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

  Future<void> checkLocationServiceAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
  }

  Future<Position> getCurrentLocation() async {
    checkLocationServiceAndPermission();
    LocationPermission permission;
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
      getPlaceNameFromCoordinates(userLat.value, userLong.value, false);
      userLocationPicking.value = false;
    } catch (e) {
      userLocationPicking.value = false;
      log('Failed to get location: $e');
    }
  }

  Future<void> getPlaceNameFromCoordinates(
      double latitude, double longitude, bool destination) async {
    if (destination == false) {
      myPlaceName.value = "Searching for you on the map..";
    }
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if (destination) {
          destinationPlaceName.value =
              '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
          destinationController.text = destinationPlaceName.value;
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
              event.docs[index].data()));

      cardriverMarkerList.value = driverList
          .where(
              (driver) => driver.latLng != null && driver.vehicleType == "car")
          .map((driver) =>
              LatLng(driver.latLng.latitude, driver.latLng.longitude))
          .toList();

      motodriverMarkerList.value = driverList
          .where(
              (driver) => driver.latLng != null && driver.vehicleType == "moto")
          .map((driver) =>
              LatLng(driver.latLng.latitude, driver.latLng.longitude))
          .toList();

      cngdriverMarkerList.value = driverList
          .where(
              (driver) => driver.latLng != null && driver.vehicleType == "cng")
          .map((driver) =>
              LatLng(driver.latLng.latitude, driver.latLng.longitude))
          .toList();

      loadMarkers();
    });
  }

  var sortedDriverList = [].obs;

  List<UserModel> sortDriversByDistance(var originalList, LatLng center) {
    List<UserModel> sortedList = List.from(originalList);

    sortedList.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        a.latLng?.latitude ?? 0.0,
        a.latLng?.longitude ?? 0.0,
      );
      double distanceB = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        b.latLng?.latitude ?? 0.0,
        b.latLng?.longitude ?? 0.0,
      );

      return distanceA.compareTo(distanceB); // Ascending order
    });

    return sortedList;
  }

  var calledTrip = [].obs;
  var bidderList = [].obs;
  Future<void> listenCalledTrip(String docId) async {
    PassengerRepository().listenToCalledTrip(docId).listen((snapshot) {
      calledTrip.clear();
      bidderList.clear();
      if (snapshot.exists) {
        calledTrip.add(Trip.fromJson(snapshot.data() as Map<String, dynamic>));
        bidderList.addAll(calledTrip[0].bids);
        log("check length logID:ahdsasffa:${bidderList.length.toString()}");
        if (calledTrip[0].dropped) {
          riderFound.value = false;
          tripCalled.value = false;
          polyLines.clear();
          polylineCoordinates.clear();
        }
      } else {
        log('Document does not exist');
      }
    });
  }

  var tripCalled = false.obs;
  var riderFound = false.obs;
  var thisDriver = [].obs;
  var thisDriverDetails = [].obs;

  Future<void> callTrip() async {
    sortedDriverList.clear();
    sortedDriverList
        .addAll(sortDriversByDistance(driverList, startPickedCenter.value));
    var bidList = [];
    for (var driver in sortedDriverList) {
      await Future.delayed(Duration(seconds: 3));
      bidList.add(Bid(
          bidStart: DateTime.now(),
          driverAccept: false,
          driverDecline: false,
          driverId: driver.uid,
          driverName: driver.name,
          offerPrice: "100",
          driverOffer: "0",
          driverPhoto: driver.photo));
    }

    tripCalled.value = true;
    String tripId = generateUniqueId();
    Trip trip = Trip(
        userId: "8mCWZ9uBrWME2Bfm9YOCvb0U2EJ3",
        bids: bidList.map((e) => e as Bid).toList(),
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

    // for (int i = 0; i < sortedDriverList.length; i++) {
    //   if (sortedDriverList[i].latLng != null &&
    //       calledTrip[0].accepted == false &&
    //       calledTrip[0].driverCancel == false) {
    //     log("sdfsdfafd6486sdg");
    //     tempDriverMarkerList.clear();

    //    // await PassengerRepository().callDriver(tripId, sortedDriverList[i].uid);
    //     // if (mapController != null) {
    //     //   tempDriverMarkerList.add(LatLng(sortedDriverList[i].latLng.latitude,
    //     //       sortedDriverList[i].latLng.longitude));
    //     //   loadMarkers();
    //     //   await mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
    //     //       sortedDriverList[i].latLng.latitude,
    //     //       sortedDriverList[i].latLng.longitude)));
    //     // }
    //     for (int j = 0; j < 7; j++) {
    //       log("calling for $j seconds");
    //       if (calledTrip[0].accepted == false) {
    //         await Future.delayed(Duration(seconds: 1));
    //       } else {
    //         log("Driver found : ${thisDriver.length.toString()}");
    //         riderFound.value = true;
    //         tripCalled.value = false;
    //         thisDriver.add(sortedDriverList[i]);
    //         thisDriverDetails.clear();
    //         thisDriverDetails.add(await AuthRepository()
    //             .getCurrentUserDriverData(userId: sortedDriverList[i].uid));
    //         break;
    //       }
    //     }
    //   }
    // }
    // if (thisDriver.isEmpty) {
    //   await PassengerRepository().callDriver(tripId, "");
    // }
    tripCalled.value = false;
    //loadMarkers();
  }

  Future<void> acceptBid({required String driverId}) async {
    await PassengerRepository().callDriver(calledTrip[0].tripId, driverId);
    var myRider = sortedDriverList
        .firstWhere((driver) => driver.uid == driverId, orElse: () => null);
    riderFound.value = true;
    tripCalled.value = false;
    thisDriver.add(myRider);
    thisDriverDetails.clear();
    // thisDriverDetails
    //     .add(await AuthRepository().getCurrentUserDriverData(userId: driverId));
  }

  String calculateDistance(
      {required GeoPoint point1, required GeoPoint point2}) {
    final distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.floor().toStringAsFixed(2)} meters';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(2)} km';
    }
  }

  int calculateRentPrice({required GeoPoint point1, required GeoPoint point2}) {
    final distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);
    return (distanceInMeters * 0.01).ceil();
  }

  String calculateTravelTime(
      {required GeoPoint point1,
      required GeoPoint point2,
      required double speedKmh}) {
    final distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);

    final distanceInKm = distanceInMeters / 1000;
    final timeInHours = distanceInKm / speedKmh;
    final timeInMinutes = timeInHours * 60;

    if (timeInMinutes < 60) {
      return timeInMinutes < 2
          ? "Less than 2 minutes"
          : '${timeInMinutes.ceil()} minutes';
    } else {
      final hours = timeInMinutes ~/ 60;
      final minutes = timeInMinutes % 60;
      return '${hours} hours ${minutes.toStringAsFixed(2)} minutes';
    }
  }
}
