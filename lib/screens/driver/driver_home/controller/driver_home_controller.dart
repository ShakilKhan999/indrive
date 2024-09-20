import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:callandgo/models/trip_model.dart';
import 'package:callandgo/screens/driver/driver_home/repository/driver_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../../helpers/method_helper.dart';
import '../../../../utils/app_config.dart';
import '../../../../utils/database_collection_names.dart';
import '../../../auth_screen/controller/auth_controller.dart';

class DriverHomeController extends GetxController {
  var userLat = 0.0.obs;
  var userLong = 0.0.obs;
  var cameraMoving = false.obs;
  var center = const LatLng(23.80, 90.41).obs;

  final TextEditingController offerPriceController = TextEditingController();

  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  AuthController authController = Get.put(AuthController());
  @override
  void onInit() {
    polyLines.clear();
    polylineCoordinates.clear();

    authController.getUserData();
    getUserLocation();
    getAngle();
    listenCall();
    listenToTrips(authController.currentUser.value.uid!);
    super.onInit();
  }

  var myActiveTrips = [].obs;

  double? _direction;
  void getAngle() {
    FlutterCompass.events?.listen((CompassEvent event) {
      AuthController authController = Get.find();
      if (event.heading != null) {
        _direction = event.heading;
        if (authController.currentUser.value.vehicleAngle != null) {
          double previousAngle = authController.currentUser.value.vehicleAngle!;

          if (isSignificantChange(event.heading!, previousAngle)) {
            updateAngle();
          }
        } else {
          updateAngle();
        }
      } else {
        print('Device does not have a compass');
      }
    });
  }

  Position? _currentPosition;
  StreamSubscription<Position>? positionStreamSubscription;

  updateUserLocation({required double lat, required double long}) async {
    try {
      Map<String, dynamic> updateData = {
        "latlng": GeoPoint(
          lat,
          long,
        )
      };
      AuthController authController = Get.find();
      MethodHelper().updateDocFields(
          docId: authController.currentUser.value.uid!,
          fieldsToUpdate: updateData,
          collection: userCollection);
    } catch (e) {
      userLocationPicking.value = false;
      log('Failed to get location: $e');
    }
  }

  updateAngle() {
    AuthController authController = Get.find();
    Map<String, dynamic> data = {
      "vehicleAngle": double.parse(_direction!.toStringAsFixed(2)),
    };
    MethodHelper().updateDocFields(
        docId: authController.currentUser.value.uid!,
        fieldsToUpdate: data,
        collection: userCollection);
  }

  bool isSignificantChange(double currentDirection, double lastDirection) {
    return (currentDirection - lastDirection).abs() >= 5;
  }

  void listenToTrips(String driverId) {
    DriverRepository().getTripsByDriverId(driverId).listen((trips) {
      myActiveTrips.clear();
      myActiveTrips.addAll(trips);
      // Additional logic here if needed, like updating UI
      print("Updated list of trips: ${myActiveTrips.length} trips found.");
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> checkLocationServiceAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
  }

  Future<Position> getCurrentLocation() async {
    log("getCurrentLocation called");

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

    positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update only if moved 10 meters
      ),
    ).listen((Position position) {
      _currentPosition = position;
      updateUserLocation(
          lat: _currentPosition!.latitude, long: _currentPosition!.longitude);
    });

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
      userLocationPicking.value = false;
    } catch (e) {
      userLocationPicking.value = false;
      log('Failed to get location: $e');
    }
  }

  AudioPlayer audioPlayer = AudioPlayer();

  void playSound() async {
    try {
      await audioPlayer.play(UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
      print('Audio is playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  String generateUniqueId({int length = 10}) {
    var uuid = const Uuid();
    String fullUuid = uuid.v4().replaceAll('-', '');
    return fullUuid.substring(0, length);
  }

  var activeCall = [].obs;
  var onTheWay = [].obs;
  Future<void> listenCall() async {
    DriverRepository()
        .listenToCall(authController.currentUser.value.uid!)
        .listen((event) {
      activeCall.value = List.generate(
          event.docs.length,
          (index) =>
              Trip.fromJson(event.docs[index].data() as Map<String, dynamic>));

      if (activeCall.isNotEmpty) {
        // if(activeCall[0].accepted == true && activeCall[0].picked == false) {
        //   getPolyline(picking: true);
        // }
        // else if (activeCall[0].accepted == true && activeCall[0].picked == true) {
        //   getPolyline(picking: false);
        // }

        //playSound();
      } else {
        // audioPlayer.stop();
        // audioPlayer.dispose();
      }

      log("active call length: ${activeCall.length.toString()}");
    });
  }

  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;

  getPolyline({required bool picking}) async {
    polyLines.clear();
    polylineCoordinates.clear();
    log("making direction polyline");
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      picking
          ? PointLatLng(center.value.latitude, center.value.longitude)
          : PointLatLng(activeCall[0].pickLatLng.latitude,
              activeCall[0].pickLatLng.longitude),
      picking
          ? PointLatLng(activeCall[0].pickLatLng.latitude,
              activeCall[0].pickLatLng.longitude)
          : PointLatLng(activeCall[0].dropLatLng.latitude,
              activeCall[0].dropLatLng.longitude),
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

    addPolyLine(polylineCoordinates
        .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
        .toList());
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
}
