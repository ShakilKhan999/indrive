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
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
var findingRoutes=false.obs;
  getPolyline() async {
    findingRoutes.value=true;
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
    findingRoutes.value=false;
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
    0.0, 45.0, 90.0,
  ];

  Future<void> loadMarkers() async {
    await Future.delayed(const Duration(seconds: 1));
    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/marker.png',
    );
   var listToMarked= tripCalled.value || riderFound.value?tempDriverMarkerList:driverMarkerList;
    Set<Marker> markers =
    listToMarked.value.asMap().entries.map((entry) {
      int idx = entry.key;
      LatLng location = entry.value;
      double rotation =
      _rotations[idx % _rotations.length]; // Cycle through rotations

      return Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: markerIcon,
        rotation: rotation,
      );
    }).toSet();

    allMarkers.value = markers;
      log("marker length: ${allMarkers.length}");

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


  var changingPickup=false.obs;
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
    getPlaceNameFromCoordinates(
        destinationPickedCenter.value.latitude, destinationPickedCenter.value.longitude,true);
  }

  void onCameraIdle() {
    cameraMoving.value = false;
    log("camera Idle");
    getPlaceNameFromCoordinates(
        startPickedCenter.value.latitude, startPickedCenter.value.longitude,false);

  }

  Future<Position> getCurrentLocation() async {
    log("getCurrentLocation called");

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
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

    // If permission is granted, get the current position
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
    if(destination==false)
      {
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
              event.docs[index].data() as Map<String, dynamic>));

      driverMarkerList.value = driverList
          .where((driver) => driver.latLng != null)
          .map((driver) =>
              LatLng(driver.latLng.latitude, driver.latLng.longitude))
          .toList();

      loadMarkers();
    });
  }

var sortedDriverList=[].obs;

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
  Future<void> listenCalledTrip(String docId) async {
        PassengerRepository().listenToCalledTrip(docId).listen((snapshot) {
          calledTrip.clear();
      if (snapshot.exists) {
        calledTrip.add(Trip.fromJson(snapshot.data() as Map<String, dynamic>));
        log("jksdfmsdn:${calledTrip.length.toString()}");
        if(calledTrip[0].dropped)
          {
            riderFound.value=false;
            tripCalled.value=false;
            polyLines.clear();
            polylineCoordinates.clear();
          }
      } else {
        log('Document does not exist');
      }
    });

  }

  var tripCalled = false.obs;
  var riderFound=false.obs;
  var thisDriver=[].obs;
  var thisDriverDetails=[].obs;
  Future<void> callTrip() async {
    sortedDriverList.clear();
    sortedDriverList.addAll(sortDriversByDistance(driverList, startPickedCenter.value));
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

    for (int i = 0; i < sortedDriverList.length; i++) {
      if (sortedDriverList[i].latLng != null &&
          calledTrip[0].accepted == false &&
          calledTrip[0].driverCancel == false) {
        log("sdfsdfafd6486sdg");
        tempDriverMarkerList.clear();

        await PassengerRepository().callDriver(tripId, sortedDriverList[i].uid);
        if (mapController != null) {
          tempDriverMarkerList.add(LatLng(sortedDriverList[i].latLng.latitude,
              sortedDriverList[i].latLng.longitude));
          loadMarkers();
          await mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
              sortedDriverList[i].latLng.latitude,
              sortedDriverList[i].latLng.longitude)));
        }
        for(int j=0;j<7;j++)
          {
            log("calling for $j seconds");
            if(calledTrip[0].accepted == false)
              {
                await Future.delayed(Duration(seconds: 1));
              }
            else
              {
                log("Driver found : ${thisDriver.length.toString()}");
                riderFound.value=true;
                tripCalled.value = false;
                thisDriver.add(sortedDriverList[i]);
                thisDriverDetails.clear();
                thisDriverDetails.add(await AuthRepository().getCurrentUserDriverData(userId: sortedDriverList[i].uid));
                break;
              }

          }
      }
    }
    if(thisDriver.isEmpty)
      {
        await PassengerRepository().callDriver(tripId, "");
      }
    tripCalled.value = false;
    loadMarkers();
  }

  String calculateDistance({required GeoPoint point1, required GeoPoint point2}) {
    final distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.floor().toStringAsFixed(2)} meters';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(2)} km';
    }
  }

  String calculateTravelTime(
      {required GeoPoint point1,required GeoPoint point2,required double speedKmh}) {
    final distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);

    final distanceInKm = distanceInMeters / 1000;
    final timeInHours = distanceInKm / speedKmh;
    final timeInMinutes = timeInHours * 60;

    if (timeInMinutes < 60) {
      return timeInMinutes<2?"Less than 2 minutes":'${timeInMinutes.toStringAsFixed(2)} minutes';
    } else {
      final hours = timeInMinutes ~/ 60;
      final minutes = timeInMinutes % 60;
      return '${hours} hours ${minutes.toStringAsFixed(2)} minutes';
    }
  }

}
