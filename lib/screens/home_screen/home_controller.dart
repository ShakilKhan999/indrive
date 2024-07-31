import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:indrive/utils/app_config.dart';

class HomeController extends GetxController{
  var selectedVehicle="car".obs;
  var  userLat=0.0.obs;
  var  userLong=0.0.obs;
  var cameraMoving=false.obs;
  var pickingDestination=false.obs;
  var suggestedPlaces=[].obs;



  var myPlaceName="Searching for you on the map..".obs;
  var destinationPlaceName="".obs;
  var center =  const LatLng(23.80, 90.41).obs;
  var lastPickedCenter =  const LatLng(23.80, 90.41).obs;
  var destinationPickedCenter =  const LatLng(23.80, 90.41).obs;
  var startPickedCenter =  const LatLng(23.80, 90.41).obs;
  @override
  void onInit() {
    super.onInit();
  }
  final TextEditingController destinationController= TextEditingController();
  GooglePlace googlePlace =
  GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraMove(CameraPosition position) {
    log("camera Moving");
    lastPickedCenter.value=LatLng(position.target.latitude, position.target.longitude);
    if(pickingDestination.value)
      {
        destinationPickedCenter.value=LatLng(position.target.latitude, position.target.longitude);
      }
    else{
      startPickedCenter.value=LatLng(position.target.latitude, position.target.longitude);
    }
   cameraMoving.value=true;
  }
  void onCameraIdle() {
    log("camera Idle");
    getPlaceNameFromCoordinates(lastPickedCenter.value.latitude, lastPickedCenter.value.longitude);
    cameraMoving.value=false;
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
var userLocationPicking=false.obs;
  void getUserLocation() async {
    userLocationPicking.value=true;
    log("getUserLocation called");
    try {
      Position position = await getCurrentLocation();
      userLat.value=position.latitude;
      userLong.value=position.longitude;
      log("user long ${userLong.value}");
      center.value=LatLng(userLat.value, userLong.value);
      mapController.animateCamera(CameraUpdate.newLatLng(center.value),);
      getPlaceNameFromCoordinates(userLat.value, userLong.value);
      userLocationPicking.value=false;
    } catch (e) {
      userLocationPicking.value=false;
      log('Failed to get location: $e');
    }
  }

  Future<void> getPlaceNameFromCoordinates(double latitude, double longitude) async {
    myPlaceName.value="Searching for you on the map..";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if(pickingDestination.value)
          {
            destinationPlaceName.value = '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
            destinationController.text=destinationPlaceName.value;
          }
        else{
          myPlaceName.value = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
        }

        log("myPlaceName: ${myPlaceName.value}");
      } else {
       log("Unknown place");
      }
    } catch (e) {
      log("Error getting place name: $e");

    }
  }

}