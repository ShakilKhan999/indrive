import 'dart:async';
import 'dart:developer';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/utils/database_collection_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:callandgo/models/trip_model.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/home/repository/passenger_repositoy.dart';
import 'package:callandgo/utils/app_config.dart';
import 'package:uuid/uuid.dart';

import '../../../models/user_model.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  var selectedVehicle = "car".obs;
  var ratingToAdd=3.0.obs;
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
  var center = const LatLng(31.7917, -7.0926).obs;
  var lastPickedCenter = const LatLng(31.7917, -7.0926).obs;
  var destinationPickedCenter = const LatLng(31.7917, -7.0926).obs;
  var startPickedCenter = const LatLng(31.7917, -7.0926).obs;
  var multiPickedCenter = const LatLng(31.7917, -7.0926).obs;

  var isOnline = false.obs;

  void toggleOnlineStatus(bool value) {
    isOnline.value = value;
  }

  var previousTrips = [].obs;
  AuthController authController = Get.put(AuthController());
  @override
  void onInit() {
    authController.getUserData();
    getAngle();
    getDriverList();




    // getPrevTrips();
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    ever(thisDriver, (value) {
      if (thisDriver.isNotEmpty) {
        // getPickupPolyline();
      }
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  //final TextEditingController destinationController = TextEditingController();
  var destinationController = TextEditingController().obs;
  final TextEditingController addRouteController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  late GoogleMapController mapMultiController;
  late GoogleMapController mapControllerTO;
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = <LatLng>[].obs;
  var findingRoutes = false.obs;
  double? _direction;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      log("App is paused, perform any action");
    } else if (state == AppLifecycleState.detached) {
      PassengerRepository().removeThisTrip("08f9b03306");
      log("App is being killed, perform cleanup");
    }
  }




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

  updateAngle() {
    Map<String, dynamic> data = {
      "vehicleAngle": double.parse(_direction!.toStringAsFixed(2)),
    };
    MethodHelper().updateDocFields(
        docId: FirebaseAuth.instance.currentUser!.uid,
        fieldsToUpdate: data,
        collection: userCollection);
  }

  bool isSignificantChange(double currentDirection, double lastDirection) {
    return (currentDirection - lastDirection).abs() >= 5;
  }

  getPolyline({TravelMode travelMode = TravelMode.driving}) async {
    findingRoutes.value = true;
    polyLines.clear();
    polylineCoordinates.clear();
    allMarkers.removeWhere((marker) =>
        marker.markerId == MarkerId("startPoint") ||
        marker.markerId == MarkerId("endPoint"));

    LatLng stPoint = LatLng(
        startPickedCenter.value.latitude, startPickedCenter.value.longitude);
    LatLng endPoint = LatLng(destinationPickedCenter.value.latitude,
        destinationPickedCenter.value.longitude);

    allMarkers.add(Marker(
      markerId: MarkerId("startPoint"),
      position: stPoint,
      infoWindow: InfoWindow(title: "Pickup Point"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));

    allMarkers.add(Marker(
      markerId: MarkerId("endPoint"),
      position: endPoint,
      infoWindow: InfoWindow(title: "Destination Point"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(stPoint.latitude, stPoint.longitude),
      PointLatLng(endPoint.latitude, endPoint.longitude),
      travelMode: travelMode,
    );

    log("polyLineResponse: ${result.points.length}");
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
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

    // minOfferPrice.value = calculateRentPrice(
    //     point1: GeoPoint(startPickedCenter.value.latitude,
    //         startPickedCenter.value.longitude),
    //     point2: GeoPoint(destinationPickedCenter.value.latitude,
    //         destinationPickedCenter.value.longitude));

    // offerPriceController.text = minOfferPrice.value.toString();
  }
  // getPolylineForMultipleRoute(
  //     {TravelMode travelMode = TravelMode.driving}) async {
  //   findingRoutes.value = true;
  //   polyLines.clear();
  //   polylineCoordinates.clear();
  //   allMarkers.removeWhere((marker) =>
  //       marker.markerId == MarkerId("startPoint") ||
  //       marker.markerId == MarkerId("endPoint"));

  //   for (int i = 0; i < routes.length; i++) {
  //     LatLng stPoint = LatLng(
  //         routes[i].pickupLatLng!.latitude, routes[i].pickupLatLng!.longitude);
  //     LatLng endPoint = LatLng(routes[i].destinationLatLng!.latitude,
  //         routes[i].destinationLatLng!.longitude);

  //     allMarkers.add(Marker(
  //       markerId: MarkerId("startPoint$i"),
  //       position: stPoint,
  //       infoWindow: InfoWindow(title: "Pickup Point"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //     ));

  //     allMarkers.add(Marker(
  //       markerId: MarkerId("endPoint$i"),
  //       position: endPoint,
  //       infoWindow: InfoWindow(title: "Destination Point"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //     ));

  //     PolylinePoints polylinePoints = PolylinePoints();
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       AppConfig.mapApiKey,
  //       PointLatLng(stPoint.latitude, stPoint.longitude),
  //       PointLatLng(endPoint.latitude, endPoint.longitude),
  //       travelMode: travelMode,
  //     );

  //     log("polyLineResponse: ${result.points.length}");
  //     if (result.points.isNotEmpty) {
  //       polylineCoordinates.clear();
  //       for (var point in result.points) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //     } else {
  //       log("${result.errorMessage}");
  //     }

  //     addPolyLineForMultipleRoute(polylineCoordinates, 'Route $i');
  //   }

  //   findingRoutes.value = false;

  //   minOfferPrice.value = calculateRentPrice(
  //       point1: GeoPoint(startPickedCenter.value.latitude,
  //           startPickedCenter.value.longitude),
  //       point2: GeoPoint(destinationPickedCenter.value.latitude,
  //           destinationPickedCenter.value.longitude));

  //   offerPriceController.text = minOfferPrice.value.toString();
  // }

  // getPolylineForMultipleRoute(
  //     {TravelMode travelMode = TravelMode.driving}) async {
  //   findingRoutes.value = true;

  //   // Remove only start and end markers, keep existing polylines
  //   allMarkers.removeWhere((marker) =>
  //       marker.markerId.value.startsWith("startPoint") ||
  //       marker.markerId.value.startsWith("endPoint"));

  //   for (int i = 0; i < routes.length; i++) {
  //     LatLng stPoint = LatLng(
  //         routes[i].pickupLatLng!.latitude, routes[i].pickupLatLng!.longitude);
  //     LatLng endPoint = LatLng(routes[i].destinationLatLng!.latitude,
  //         routes[i].destinationLatLng!.longitude);

  //     allMarkers.add(Marker(
  //       markerId: MarkerId("startPoint$i"),
  //       position: stPoint,
  //       infoWindow: InfoWindow(title: "Pickup Point ${i + 1}"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //     ));

  //     allMarkers.add(Marker(
  //       markerId: MarkerId("endPoint$i"),
  //       position: endPoint,
  //       infoWindow: InfoWindow(title: "Destination Point ${i + 1}"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //     ));

  //     PolylinePoints polylinePoints = PolylinePoints();
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       AppConfig.mapApiKey,
  //       PointLatLng(stPoint.latitude, stPoint.longitude),
  //       PointLatLng(endPoint.latitude, endPoint.longitude),
  //       travelMode: travelMode,
  //     );

  //     if (result.points.isNotEmpty) {
  //       List<LatLng> routePolylineCoordinates = result.points
  //           .map((point) => LatLng(point.latitude, point.longitude))
  //           .toList();
  //       addPolyLineForMultipleRoute(routePolylineCoordinates, 'Route $i');
  //     } else {
  //       log("Error for Route $i: ${result.errorMessage}");
  //     }
  //   }

  //   findingRoutes.value = false;

  //   // Update the camera to show all polylines
  //   // moveCameraToFitPolylines();
  // }

  var polilineString = <String>[].obs;

  getPolylineForMultipleRoute(
      {TravelMode travelMode = TravelMode.driving}) async {
    findingRoutes.value = true;

    // Clear all existing markers and polylines
    // allMarkers.clear();
    allMarkers.removeWhere((marker) =>
        marker.markerId.value.contains("startPoint") ||
        marker.markerId.value.contains("endPoint"));
    polylines.clear();
    polilineString.clear();

    for (int i = 0; i < routes.length; i++) {
      LatLng stPoint = LatLng(
          routes[i].pickupLatLng!.latitude, routes[i].pickupLatLng!.longitude);
      LatLng endPoint = LatLng(routes[i].destinationLatLng!.latitude,
          routes[i].destinationLatLng!.longitude);

      allMarkers.add(Marker(
        markerId: MarkerId("startPoint$i"),
        position: stPoint,
        infoWindow: InfoWindow(title: "Pickup Point ${i + 1}"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));

      allMarkers.add(Marker(
        markerId: MarkerId("endPoint$i"),
        position: endPoint,
        infoWindow: InfoWindow(title: "Destination Point ${i + 1}"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppConfig.mapApiKey,
        PointLatLng(stPoint.latitude, stPoint.longitude),
        PointLatLng(endPoint.latitude, endPoint.longitude),
        travelMode: travelMode,
      );

      if (result.points.isNotEmpty) {
        List<LatLng> routePolylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        String encodedPolyline = encodePolyline(routePolylineCoordinates);
        polilineString.add(encodedPolyline);

        addPolyLineForMultipleRoute(routePolylineCoordinates, 'Route $i');
      } else {
        log("Error for Route $i: ${result.errorMessage}");
      }
    }

    findingRoutes.value = false;

    minOfferPrice.value = calculateRentPrice(routes: routes);

    offerPriceController.text = minOfferPrice.value.toString();

    // Update the camera to show all polylines
    // moveCameraToFitPolylines();
  }

  Map<String, Polyline> polylines = {};

  void addPolyLineForMultipleRoute(
      List<LatLng> polylineCoordinates, String polylineId) {
    final id = PolylineId(polylineId);
    final polyline = Polyline(
      polylineId: id,
      color: ColorHelper.primaryColor,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[polylineId] = polyline;
  }

  String encodePolyline(List<LatLng> points) {
    int plat = 0;
    int plng = 0;
    String encoded = "";

    for (LatLng point in points) {
      int late5 = (point.latitude * 1e5).round();
      int lnge5 = (point.longitude * 1e5).round();

      encoded += _encodeNumber(late5 - plat);
      encoded += _encodeNumber(lnge5 - plng);

      plat = late5;
      plng = lnge5;
    }

    return encoded;
  }

  String _encodeNumber(int num) {
    num = (num < 0) ? ~(num << 1) : (num << 1);
    String result = "";
    while (num >= 0x20) {
      result += String.fromCharCode((0x20 | (num & 0x1f)) + 63);
      num >>= 5;
    }
    result += String.fromCharCode(num + 63);
    return result;
  }

  getPickupPolyline() async {
    findingRoutes.value = true;
    polyLines.clear();
    polylineCoordinates.clear;

    LatLng stPoint =
        LatLng(thisDriver[0].latLng.latitude, thisDriver[0].latLng.longitude);

    LatLng endPoint = LatLng(
        startPickedCenter.value.latitude, startPickedCenter.value.longitude);
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(stPoint.latitude, stPoint.longitude),
      PointLatLng(endPoint.latitude, endPoint.longitude),
      travelMode: TravelMode.driving,
    );
    log("polyLineResponse: ${result.points.length}");
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
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
      'assets/images/motoMarker.png',
    );
    final BitmapDescriptor markerIconCng =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/taxiMarker.png',
    );

    if (selectedVehicle.value == "car") {
      Set<Marker> markers = cardriverMarkerList.value.map((driver) {
        LatLng latLng = LatLng(driver.latLng.latitude,
            driver.latLng.longitude); // Extract LatLng from driver
        return Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: markerIconCar,
          rotation: driver.vehicleAngle ?? 0.0, // Use vehicleAngle for rotation
        );
      }).toSet();

      allMarkers.value = markers;
      log("car marker length: ${allMarkers.length}");
    } else if (selectedVehicle.value == "moto") {
      Set<Marker> markers = motodriverMarkerList.value.map((driver) {
        LatLng latLng = LatLng(driver.latLng.latitude,
            driver.latLng.longitude); // Extract LatLng from driver
        return Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: markerIconMoto,
          rotation: driver.vehicleAngle ?? 0.0, // Use vehicleAngle for rotation
        );
      }).toSet();

      allMarkers.value = markers;
      log("moto marker length: ${allMarkers.length}");
    } else if (selectedVehicle.value == "cng") {
      Set<Marker> markers = cngdriverMarkerList.value.map((driver) {
        LatLng latLng = LatLng(driver.latLng.latitude,
            driver.latLng.longitude); // Extract LatLng from driver
        return Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: markerIconCng,
          rotation: driver.vehicleAngle ?? 0.0, // Use vehicleAngle for rotation
        );
      }).toSet();

      allMarkers.value = markers;

      log("cng marker length: ${allMarkers.length}");
    }

    // if (polylineCoordinates.isNotEmpty) {
    //   allMarkers.add(Marker(
    //     markerId: MarkerId("startPoint"),
    //     position: polylineCoordinates[0],
    //     infoWindow: InfoWindow(title: "Pickup Point"),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //   ));

    //   allMarkers.add(Marker(
    //     markerId: MarkerId("endPoint"),
    //     position: polylineCoordinates[polylineCoordinates.length - 1],
    //     infoWindow: InfoWindow(title: "Destination Point"),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    //   ));
    // }
    if (routes.isNotEmpty) {
      for (int i = 0; i < routes.length; i++) {
        allMarkers.add(Marker(
          markerId: MarkerId("startPoint$i"),
          position: LatLng(routes[i].pickupLatLng!.latitude,
              routes[i].pickupLatLng!.longitude),
          infoWindow: InfoWindow(title: "Pickup Point ${i + 1}"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));

        if (i == routes.length - 1) {
          allMarkers.add(Marker(
            markerId: MarkerId("endPoint$i"),
            position: LatLng(routes[i].destinationLatLng!.latitude,
                routes[i].destinationLatLng!.longitude),
            infoWindow: InfoWindow(title: "Destination Point ${i + 1}"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        } else {
          allMarkers.add(Marker(
            markerId: MarkerId("endPoint$i"),
            position: LatLng(routes[i].destinationLatLng!.latitude,
                routes[i].destinationLatLng!.longitude),
            infoWindow: InfoWindow(title: "Destination Point ${i + 1}"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ));
        }
      }
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

  void onMultiMapCreated(GoogleMapController controller) {
    mapMultiController = controller;
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

  void onMultiCameraMove(CameraPosition position) {
    log("camera Moving");
    destinationPickedCenter.value =
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

  void onMultiCameraIdle() {
    cameraMoving.value = false;
    log("camera Idle");
    getPlaceNameFromCoordinates(destinationPickedCenter.value.latitude,
        destinationPickedCenter.value.longitude, false);
  }

  Future<void> checkLocationServiceAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
  }

  Position? _currentPosition;
  StreamSubscription<Position>? positionStreamSubscription;

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
    return await Geolocator.getCurrentPosition();
  }

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
      mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(center.value.latitude, center.value.longitude)));

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
          destinationController.value.text = destinationPlaceName.value;
        } else {
          myPlaceName.value =
              '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
          pickupController.text = myPlaceName.value;
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
    PassengerRepository().listenToDriverDocs().listen((event) async {
      driverList.value = List.generate(event.docs.length,
          (index) => UserModel.fromJson(event.docs[index].data()));
      await filterRider();
    });
  }

  Future<void> filterRider() async {
    cardriverMarkerList.clear();
    motodriverMarkerList.clear();
    cngdriverMarkerList.clear();

    cardriverMarkerList.addAll(driverList
        .where((driver) => driver.latLng != null && driver.vehicleType == "car")
        .toList());

    log("CarDriverList: ${cardriverMarkerList.length.toString()}");

    motodriverMarkerList.addAll(driverList
        .where(
            (driver) => driver.latLng != null && driver.vehicleType == "moto")
        .toList());
    log("MotoDriverList: ${motodriverMarkerList.length.toString()}");

    cngdriverMarkerList.addAll(driverList
        .where((driver) => driver.latLng != null && driver.vehicleType == "cng")
        .toList());
    log("CngDriverList: ${cngdriverMarkerList.length.toString()}");

    loadMarkers();
  }

  var sortedDriverList = [].obs;

  List<UserModel> sortDriversByDistance(var originalList, LatLng center) {
    var filteredList = originalList.where((driver) {
      double distance = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        driver.latLng?.latitude ?? 0.0,
        driver.latLng?.longitude ?? 0.0,
      );
      return distance <= 5000; // Filter drivers within 5000 meters
    }).toList();

    filteredList.sort((a, b) {
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

    return List<UserModel>.from(filteredList);;
  }

  var calledTrip = [].obs;
  var bidderList = [].obs;

  int count = 0;
  var rateDriver = false.obs;
  var driverToRate = [].obs;
  var lastTrip = "".obs;

  StreamSubscription? _tripSubscription;
  var routeIndex = 0.obs;
  Future<void> listenCalledTrip(String docId) async {
    _tripSubscription =
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
          allMarkers.clear();

          driverToRate.add(thisDriver[0]);
          lastTrip.value=calledTrip[0].tripId;
          rateDriver.value = true;
        } else if (calledTrip[0].accepted == false &&
            calledTrip[0].driverCancel == true) {
          riderFound.value = false;
          tripCalled.value = false;
          polyLines.clear();
          polylineCoordinates.clear();
          stopListeningToCalledTrip();
          calledTrip().clear();
          showToast("Driver cancelled the trip");
        } else if (calledTrip[0].accepted) {
          log("jhscscsndmnsmndmmvsdmn");
          riderFound.value = true;
          thisDriver.clear();
          var myRider = sortedDriverList.firstWhere(
              (driver) => driver.uid == calledTrip[0].driverId,
              orElse: () => null);
          thisDriver.add(myRider);
          tripCalled.value = false;
          int index = calledTrip[0]
              .routes
              .indexWhere((route) => route.currentStatus == "Pending");
          index >= 0 ? routeIndex.value = index : routeIndex.value = 0;
          calledTrip[0].picked
              ? onGoingPolyLinles(routeIndex: routeIndex.value)
              : getPickupPolyline();
        }
      } else {
        log('Document does not exist');
      }
    });
  }

  Future<void> onGoingPolyLinles({required int routeIndex}) async {
    await Future.delayed(Duration(seconds: 1));
    log("shiftingRouteinTheTrip");
    var polyLinePoints =
        decodePolyline(calledTrip[0].routes[routeIndex].encodedPolyline);
    polylineCoordinates.value = polyLinePoints;
    addPolyLineForMultipleRoute(polylineCoordinates, 'Route $routeIndex');
  }

// Method to stop the listener
  void stopListeningToCalledTrip() {
    if (_tripSubscription != null) {
      _tripSubscription!.cancel();
      _tripSubscription = null;
      log('Stopped listening to the trip updates');
    }
  }

  var tripCalled = false.obs;
  var riderFound = false.obs;
  var thisDriver = [].obs;
  var thisDriverDetails = [].obs;

  var tempTripId = "";

  var tripCalling = false.obs;
  Future<void> callTrip() async {
    tripCalling.value = true;
    String polyline = await PassengerRepository().getPolylineFromGoogleMap(
        startPickedCenter.value, destinationPickedCenter.value);
    sortedDriverList.clear();
    sortedDriverList.addAll(sortDriversByDistance(
        selectedVehicle == "cng"
            ? cngdriverMarkerList
            : selectedVehicle == "car"
                ? cardriverMarkerList
                : motodriverMarkerList,
        startPickedCenter.value));
    var bidList = [];
    for (var driver in sortedDriverList) {
      // await Future.delayed(Duration(seconds: 3));
      bidList.add(Bid(
          bidStart: null,
          driverAccept: false,
          driverDecline: false,
          driverId: driver.uid,
          driverName: driver.name,
          offerPrice: null,
          driverOffer: "0",
          driverPhoto: driver.photo));
    }

    for (int i = 0; i < routes.length; i++) {
      routes[i].encodedPolyline = polilineString[i];
    }

    tripCalled.value = true;
    String tripId = generateUniqueId();
    tempTripId = tripId;
    Trip trip = Trip(
        userId: authController.currentUser.value.uid,
        userName: authController.currentUser.value.name,
        userImage: authController.currentUser.value.photo,
        userPhone: authController.currentUser.value.phone,
        polyLineEncoded: polyline,
        rent: int.parse(offerPriceController.text),
        bids: bidList.map((e) => e as Bid).toList(),
        driverId: "",
        destination: destinationController.value.text,
        pickUp: myPlaceName.value,
        pickLatLng: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        dropLatLng: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude),
        tripId: tripId,
        driverCancel: false,
        userCancel: false,
        accepted: false,
        picked: false,
        dropped: false,
        routes: routes);

    if (selectedVehicle == "cng" && cngdriverMarkerList.isEmpty) {
      showToast("No Taxi available nearby");
    } else if (selectedVehicle == "car" && cardriverMarkerList.isEmpty) {
      showToast("No Taxi car nearby");
    } else if (selectedVehicle == "moto" && motodriverMarkerList.isEmpty) {
      showToast("No Moto available nearby");
    } else {
      await PassengerRepository().addNewTrip(trip);

      listenCalledTrip(tripId);

      for (int i = 0; i < 60; i++) {
        if (selectedVehicle == "cng" && cngdriverMarkerList.isEmpty) {
          showToast("No Taxi available nearby");
          break;
        } else if (selectedVehicle == "car" && cardriverMarkerList.isEmpty) {
          showToast("No Taxi car nearby");
          break;
        } else if (selectedVehicle == "moto" && motodriverMarkerList.isEmpty) {
          showToast("No Moto available nearby");
          break;
        } else if (riderFound.value == true && calledTrip.isNotEmpty) {
          showToast("Driver found");
          break;
        } else if (i == 59) {
          showToast("Busy hours, Please try again later");
          PassengerRepository().removeThisTrip(tripId);
        } else if (tripCalled == false) {
          break;
        }
        await Future.delayed(Duration(seconds: 1));
      }
    }

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
    tripCalling.value = false;
    //loadMarkers();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> acceptBid({required String driverId, required int rent}) async {
    await PassengerRepository()
        .callDriver(calledTrip[0].tripId, driverId, rent);
    var myRider = sortedDriverList
        .firstWhere((driver) => driver.uid == driverId, orElse: () => null);
    riderFound.value = true;
    tripCalled.value = false;
    thisDriver.clear();
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

  int calculateRentPrice({required List<Routes> routes}) {
    double totalDistance = 0;
    for (int i = 0; i < routes.length; i++) {
      final distanceInMeters = Geolocator.distanceBetween(
          routes[i].pickupLatLng!.latitude,
          routes[i].pickupLatLng!.longitude,
          routes[i].destinationLatLng!.latitude,
          routes[i].destinationLatLng!.longitude);
      totalDistance = totalDistance + distanceInMeters;
    }

    return (totalDistance * 0.01).ceil();
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

  Future<void> getPrevTrips() async {
    previousTrips.clear();
    previousTrips.addAll(await PassengerRepository()
        .getTripHistory(authController.currentUser.value.uid!));
    log("trip history : ${previousTrips.length.toString()}");
  }

  List<LatLng> decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = polylinePoints.decodePolyline(encoded);

    List<LatLng> coordinates = points.map((point) {
      return LatLng(point.latitude, point.longitude);
    }).toList();
    return coordinates;
  }

  var routes = <Routes>[].obs;

  generateRoutes({bool isFirst = false}) {
    if (routes.isEmpty) {
      Routes route = Routes(
        pickupPoint: myPlaceName.value,
        pickupLatLng: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        destinationPoint: destinationPlaceName.value,
        destinationLatLng: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude),
        currentStatus: 'Pending',
      );
      routes.add(route);
    } else {
      if (isFirst) {
        routes.clear();
        Routes route = Routes(
          pickupPoint: myPlaceName.value,
          pickupLatLng: GeoPoint(startPickedCenter.value.latitude,
              startPickedCenter.value.longitude),
          destinationPoint: destinationPlaceName.value,
          destinationLatLng: GeoPoint(destinationPickedCenter.value.latitude,
              destinationPickedCenter.value.longitude),
          currentStatus: 'Pending',
        );
        routes.add(route);
      } else {
        Routes route = Routes(
          pickupPoint: routes.last.destinationPoint,
          pickupLatLng: routes.last.destinationLatLng,
          destinationPoint: destinationPlaceName.value,
          destinationLatLng: GeoPoint(destinationPickedCenter.value.latitude,
              destinationPickedCenter.value.longitude),
          currentStatus: 'Pending',
        );
        routes.add(route);
      }
    }
    log('All Routes: ${routes.map((route) => route.toJson()).toList()}');
  }
}
