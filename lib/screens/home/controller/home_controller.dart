import 'dart:async';
import 'dart:developer';
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

  var previousTrips=[].obs;
  AuthController authController = Get.put(AuthController());
  @override
  void onInit() {

    authController.getUserData();
    getAngle();
    getDriverList();
    getPrevTrips();
    super.onInit();
    ever(thisDriver, (value) {
      if (thisDriver.isNotEmpty) {
        // getPickupPolyline();
      }
    });
  }

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
  var findingRoutes = false.obs;
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

  getPolyline({ TravelMode travelMode=TravelMode.driving}) async {
    findingRoutes.value = true;
    polyLines.clear();
    polylineCoordinates.clear();
    allMarkers.removeWhere((marker) =>
    marker.markerId == MarkerId("startPoint") ||
        marker.markerId == MarkerId("endPoint"));

    LatLng stPoint = LatLng(
        startPickedCenter.value.latitude, startPickedCenter.value.longitude);
    LatLng endPoint = LatLng(
        destinationPickedCenter.value.latitude, destinationPickedCenter.value.longitude);

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

    minOfferPrice.value = calculateRentPrice(
        point1: GeoPoint(startPickedCenter.value.latitude,
            startPickedCenter.value.longitude),
        point2: GeoPoint(destinationPickedCenter.value.latitude,
            destinationPickedCenter.value.longitude));

    offerPriceController.text = minOfferPrice.value.toString();
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
      'assets/images/motoMarker.png',
    );
    final BitmapDescriptor markerIconCng =
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/taxiMarker.png',
    );

    if (selectedVehicle.value == "car") {
      Set<Marker> markers = cardriverMarkerList.value.map((driver) {
        LatLng latLng = LatLng(driver.latLng.latitude, driver.latLng.longitude); // Extract LatLng from driver
        return Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: markerIconCar,
          rotation: driver.vehicleAngle??0.0, // Use vehicleAngle for rotation
        );
      }).toSet();

      allMarkers.value = markers;
      log("car marker length: ${allMarkers.length}");
    } else if (selectedVehicle.value == "moto") {
      Set<Marker> markers = motodriverMarkerList.value.map((driver) {
        LatLng latLng = LatLng(driver.latLng.latitude, driver.latLng.longitude); // Extract LatLng from driver
        return Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: markerIconMoto,
          rotation: driver.vehicleAngle??0.0, // Use vehicleAngle for rotation
        );
      }).toSet();

      allMarkers.value = markers;
      log("moto marker length: ${allMarkers.length}");
    } else if (selectedVehicle.value == "cng") {
      Set<Marker> markers = cngdriverMarkerList.value.map((driver) {
        LatLng latLng = LatLng(driver.latLng.latitude, driver.latLng.longitude); // Extract LatLng from driver
        return Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: markerIconCng,
          rotation: driver.vehicleAngle??0.0, // Use vehicleAngle for rotation
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

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

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
    _positionStreamSubscription = Geolocator.getPositionStream(
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
      mapController.animateCamera(CameraUpdate.newLatLng(LatLng(center.value.latitude, center.value.longitude)));

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
        .where((driver) => driver.latLng != null && driver.vehicleType == "car").toList());

    log("CarDriverList: ${cardriverMarkerList.length.toString()}");

    motodriverMarkerList.addAll(driverList
        .where(
            (driver) => driver.latLng != null && driver.vehicleType == "moto").toList());
    log("MotoDriverList: ${motodriverMarkerList.length.toString()}");

    cngdriverMarkerList.addAll(driverList
        .where((driver) => driver.latLng != null && driver.vehicleType == "cng").toList());
    log("CngDriverList: ${cngdriverMarkerList.length.toString()}");

    loadMarkers();
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

  int count=0;

  StreamSubscription? _tripSubscription;

  Future<void> listenCalledTrip(String docId) async {
    _tripSubscription = PassengerRepository().listenToCalledTrip(docId).listen((snapshot) {
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

        else if(calledTrip[0].accepted==false && calledTrip[0].driverCancel==true)
          {
            riderFound.value = false;
            tripCalled.value = false;
            polyLines.clear();
            polylineCoordinates.clear();
            stopListeningToCalledTrip();
            calledTrip().clear();
            showToast("Driver cancelled the trip");
          }

        else if (calledTrip[0].accepted) {
          riderFound.value = true;
          thisDriver.clear();
          var myRider = sortedDriverList.firstWhere(
                  (driver) => driver.uid == calledTrip[0].driverId,
              orElse: () => null);
          thisDriver.add(myRider);
          tripCalled.value = false;
          calledTrip[0].picked ? getPolyline() : getPickupPolyline();
        }
      } else {
        log('Document does not exist');
      }
    });
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



  Future<void> callTrip() async {

    String polyline= await PassengerRepository().getPolylineFromGoogleMap(startPickedCenter.value, destinationPickedCenter.value);
    sortedDriverList.clear();
    sortedDriverList
        .addAll(sortDriversByDistance(driverList, startPickedCenter.value));
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

    tripCalled.value = true;
    String tripId = generateUniqueId();
    tempTripId = tripId;
    Trip trip = Trip(
        userId: authController.currentUser.value.uid,
        userName: authController.currentUser.value.name,
        userImage: authController.currentUser.value.photo,
        polyLineEncoded: polyline,
        rent: int.parse(offerPriceController.text),
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

  Future<void> getPrevTrips() async{
    previousTrips.clear();
    previousTrips.addAll(await PassengerRepository().getTripHistory("8mCWZ9uBrWME2Bfm9YOCvb0U2EJ3"));
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

}
