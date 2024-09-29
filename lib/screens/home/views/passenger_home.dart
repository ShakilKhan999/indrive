import 'dart:developer';

import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/home/views/ride_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import 'package:callandgo/screens/city_to_city_user/views/city_to_city_request.dart';
import 'package:callandgo/screens/courier_user/views/courier_request_screen.dart';
import 'package:callandgo/screens/freight_user/controller/freight_trip_controller.dart';
import 'package:callandgo/screens/freight_user/view/freight_request_screen.dart';
import 'package:callandgo/screens/home/controller/home_controller.dart';
import 'package:callandgo/screens/home/repository/passenger_repositoy.dart';
import 'package:callandgo/screens/home/views/bid.dart';
import 'package:callandgo/screens/home/views/select_destination.dart';

import '../../../components/custom_drawer.dart';
import '../../courier_user/controller/courier_trip_controller.dart';
import '../../profile/views/profile_screen.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final HomeController homeController = Get.put(HomeController());
  final CityToCityTripController cityToCityTripController =
      Get.put(CityToCityTripController());
  final FreightTripController freightTripController =
      Get.put(FreightTripController());
  final CourierTripController courierTripController =
      Get.put(CourierTripController());
  final AuthController authController=Get.put(AuthController());
  @override
  void initState() {
    if (homeController.myPlaceName.value == "Searching for you on the map..") {
      homeController.getUserLocation();
    }
    homeController.getDriverList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: ColorHelper.bgColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else {
              scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
        actions: [
          Container(
            width: 40,
          )
        ],
        title: Title(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonComponents().printText(
                  fontSize: 15,
                  textData: "Searching for you on the map",
                  fontWeight: FontWeight.bold),
              CommonComponents().printText(
                  fontSize: 12,
                  textData: "please wait or enter the address below",
                  fontWeight: FontWeight.normal)
            ],
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Obx(() => SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    markers: homeController.allMarkers.cast<Marker>().toSet(),
                    polylines: {
                      Polyline(
                          polylineId: const PolylineId("route"),
                          points: homeController.polylineCoordinates.value
                              .map((geoPoint) =>
                                  LatLng(geoPoint.latitude, geoPoint.longitude))
                              .toList(),
                          color: ColorHelper.primaryColor,
                          width: 7)
                    },
                    onCameraMove:
                        homeController.polylineCoordinates.isNotEmpty ||
                                homeController.findingRoutes.value
                            ? null
                            : homeController.onCameraMove,
                    onCameraIdle:
                        homeController.polylineCoordinates.isNotEmpty ||
                                homeController.findingRoutes.value
                            ? null
                            : homeController.onCameraIdle,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    onMapCreated: homeController.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: homeController.center.value,
                      zoom: 15.0,
                    ),
                  ),
                )),
            Positioned(
              top: 150.h,
              left: 120.w,
              child: Obx(() => homeController.userLocationPicking.value
                  ? SizedBox(
                      height: 100.h,
                      width: 100.h,
                      child: Image.asset(
                        "assets/images/searching-loading.gif",
                        height: 100.h,
                        width: 100.h,
                      ),
                    )
                  : const SizedBox()),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 32.sp),
                  child: Obx(() =>
                      homeController.polylineCoordinates.isNotEmpty ||
                              homeController.userLocationPicking.value
                          ? const SizedBox()
                          : homeController.cameraMoving.value
                              ? Icon(
                                  Icons.pin_drop,
                                  color: ColorHelper.blueColor,
                                  size: 45.sp,
                                )
                              : Icon(Icons.location_on_outlined,
                                  color: ColorHelper.blueColor, size: 45.sp)),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() => AnimatedContainer(
                    duration: const Duration(microseconds: 200),
                    width: MediaQuery.of(context).size.width,
                    height: homeController.cameraMoving.value ? 0 : 300.h,
                    decoration: BoxDecoration(
                        color: ColorHelper.bgColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: _buildBottomView(context),
                  )),
            ),
            Align(
                alignment: Alignment.center,
                child: Obx(() => homeController.bidderList.isEmpty
                    ? SizedBox()
                    : Container(
                        width: 300.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: ColorHelper.blackColor.withOpacity(0.9)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: homeController.bidderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var bid = homeController.bidderList[index];
                            if (bid.offerPrice == null) {
                              return SizedBox();
                            }

                            // Initialize start time for each bid item
                            DateTime startTime = bid
                                .bidStart; // Adjust this to use the correct start time for each item if needed

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BidItem(
                                bid: bid,
                                startTime: startTime,
                                onLoadingComplete: () {
                                  PassengerRepository().removeBidByDriverId(
                                      driverId: bid.driverId,
                                      tripId:
                                          homeController.calledTrip[0].tripId);
                                },
                              ),
                            );
                          },
                        ),
                      ))),
          ],
        ),
      ),
    );
  }

  final double progress = 10;
  Widget _buildBottomView(BuildContext context) {
    return Obx(() => Column(
          children: [
            if (homeController.tripCalled.value &&
                homeController.riderFound.value == false)
              Column(
                children: [
                  SpaceHelper.verticalSpace35,
                  SpaceHelper.verticalSpace35,
                  CommonComponents().printText(
                      fontSize: 18,
                      textData: "Finding your driver",
                      fontWeight: FontWeight.bold),
                  SpaceHelper.verticalSpace15,
                  Container(
                    height: 60.h,
                    width: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.asset(
                        "assets/images/location-graphics.gif",
                        height: 60.h,
                        width: 60.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              )
            else if (homeController.tripCalled.value == false &&
                homeController.calledTrip.isNotEmpty &&
                homeController.riderFound.value == true &&
                homeController.calledTrip[0].picked == false &&
                homeController.calledTrip[0].dropped == false)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Container(
                            //   height: 50.h,
                            //   width: 50.h,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(90),
                            //   ),
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(90),
                            //     child: Image.network(
                            //       homeController.thisDriver[0].photo ??
                            //           "https://cdn-icons-png.flaticon.com/512/8583/8583437.png",
                            //       height: 50.h,
                            //       width: 50.h,
                            //       fit: BoxFit.fill,
                            //     ),
                            //   ),
                            // ),
                            SpaceHelper.horizontalSpace10,
                            CommonComponents().printText(
                                fontSize: 18,
                                textData:
                                    homeController.thisDriver[0].name ?? "",
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CommonComponents().printText(
                              fontSize: 15,
                              textData: "Distance " +
                                  homeController.calculateDistance(
                                      point1: GeoPoint(
                                          homeController
                                              .startPickedCenter.value.latitude,
                                          homeController.startPickedCenter.value
                                              .longitude),
                                      point2: GeoPoint(
                                          homeController.thisDriver[0].latLng
                                                  ?.latitude ??
                                              0.0,
                                          homeController.thisDriver[0].latLng
                                                  ?.longitude ??
                                              0.0)),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SpaceHelper.verticalSpace10,
                    Row(
                      children: [
                        CommonComponents().printText(
                            fontSize: 16,
                            textData: "Arriving on :",
                            fontWeight: FontWeight.bold),
                        SpaceHelper.horizontalSpace5,
                        CommonComponents().printText(
                            fontSize: 15,
                            textData: homeController.calculateTravelTime(
                                speedKmh: 9.0,
                                point1: GeoPoint(
                                    homeController
                                        .startPickedCenter.value.latitude,
                                    homeController
                                        .startPickedCenter.value.longitude),
                                point2: GeoPoint(
                                    homeController
                                            .thisDriver[0].latLng?.latitude ??
                                        0.0,
                                    homeController
                                            .thisDriver[0].latLng?.longitude ??
                                        0.0)),
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    SpaceHelper.verticalSpace10,
                    homeController.thisDriverDetails.isNotEmpty
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50.h,
                                    width: 50.h,
                                    child: Image.asset("assets/images/car.png",
                                        height: 50.h, width: 50.h),
                                  ),
                                  SpaceHelper.horizontalSpace10,
                                  homeController.thisDriverDetails.isEmpty
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            CommonComponents().printText(
                                                fontSize: 18,
                                                textData: homeController
                                                        .thisDriverDetails[0]
                                                        .vehicleBrand ??
                                                    "",
                                                fontWeight: FontWeight.bold),
                                            CommonComponents().printText(
                                                fontSize: 18,
                                                textData: homeController
                                                        .thisDriverDetails[0]
                                                        .vehicleModelNo ??
                                                    "",
                                                fontWeight: FontWeight.bold),
                                          ],
                                        ),
                                  SpaceHelper.horizontalSpace10,
                                  _buildRentPriceView(initial: false)
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                    SpaceHelper.verticalSpace10,
                    SizedBox(
                        width: 250.w,
                        child: CommonComponents().commonButton(
                          borderRadius: 13,
                          text: "Cancel Ride",
                          onPressed: () async {
                            homeController.polyLines.clear();
                            homeController.polylineCoordinates.clear();
                            homeController.stopListeningToCalledTrip();
                            await PassengerRepository().cancelRide(
                                homeController.calledTrip[0].tripId, "");
                            await Future.delayed(Duration(seconds: 1));
                            homeController.tripCalled.value = false;
                            homeController.riderFound.value = false;
                            homeController.calledTrip.clear();
                          },
                        )),
                  ],
                ),
              )
            else if (homeController.tripCalled.value == false &&
                homeController.calledTrip.isNotEmpty &&
                homeController.riderFound.value == true &&
                homeController.calledTrip[0].picked == true &&
                homeController.calledTrip[0].dropped == false)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50.h,
                              width: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Image.network(
                                  homeController.thisDriver[0].photo ??
                                      "https://cdn-icons-png.flaticon.com/512/8583/8583437.png",
                                  height: 50.h,
                                  width: 50.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SpaceHelper.horizontalSpace10,
                            CommonComponents().printText(
                                fontSize: 18,
                                textData:
                                    homeController.thisDriver[0].name ?? "",
                                fontWeight: FontWeight.bold),
                            SpaceHelper.horizontalSpace10,
                            _buildRentPriceView(initial: false)
                          ],
                        ),
                        SpaceHelper.verticalSpace10,
                        homeController.thisDriverDetails.isNotEmpty
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 50.h,
                                        width: 50.h,
                                        child: Image.asset(
                                            "assets/images/car.png",
                                            height: 50.h,
                                            width: 50.h),
                                      ),
                                      SpaceHelper.horizontalSpace10,
                                      homeController.thisDriverDetails.isEmpty
                                          ? SizedBox()
                                          : Column(
                                              children: [
                                                CommonComponents().printText(
                                                    fontSize: 18,
                                                    textData: homeController
                                                            .thisDriverDetails[
                                                                0]
                                                            .vehicleBrand ??
                                                        "",
                                                    fontWeight:
                                                        FontWeight.bold),
                                                CommonComponents().printText(
                                                    fontSize: 18,
                                                    textData: homeController
                                                            .thisDriverDetails[
                                                                0]
                                                            .vehicleModelNo ??
                                                        "",
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ],
                                            )
                                    ],
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                    ProgressStack(
                      start: LatLng(homeController.calledTrip[0].pickLatLng.latitude, homeController.calledTrip[0].pickLatLng.longitude),
                      destination: LatLng(homeController.calledTrip[0].dropLatLng.latitude, homeController.calledTrip[0].dropLatLng.longitude),),
                    CommonComponents().printText(
                        fontSize: 18,
                        textData:
                            "${homeController.calculateDistance(point1: homeController.calledTrip[0].pickLatLng, point2: homeController.calledTrip[0].dropLatLng)} to go",
                        fontWeight: FontWeight.bold),
                    CommonComponents().printText(
                        fontSize: 18,
                        textData:
                            "Time: ${homeController.calculateTravelTime(point1: homeController.calledTrip[0].pickLatLng, point2: homeController.calledTrip[0].dropLatLng, speedKmh: 10)}",
                        fontWeight: FontWeight.bold),
                    SpaceHelper.verticalSpace10,
                    SizedBox(
                        width: 250.w,
                        child: CommonComponents().commonButton(
                          borderRadius: 13,
                          text: "Cancel Ride",
                          onPressed: () async {
                            homeController.polyLines.clear();
                            homeController.polylineCoordinates.clear();
                            homeController.stopListeningToCalledTrip();
                            await PassengerRepository().cancelRide(
                                homeController.calledTrip[0].tripId, "");
                            await Future.delayed(Duration(seconds: 1));
                            homeController.tripCalled.value = false;
                            homeController.riderFound.value = false;
                            homeController.calledTrip.clear();
                          },
                        )),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildVehicleSelection(),
                  SpaceHelper.verticalSpace5,
                  InkWell(
                    onTap: () {
                      homeController.changingPickup.value = true;
                      homeController.polylineCoordinates.clear();
                      homeController.polyLines.clear();
                      _buildDestinationBottomSheet(context);
                     // Get.to(SelectDestination());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpaceHelper.horizontalSpace10,
                        Icon(
                          Icons.circle_outlined,
                          color: ColorHelper.blueColor,
                          size: 25.sp,
                        ),
                        SpaceHelper.horizontalSpace5,
                        Obx(() => SizedBox(
                              width: 220.w,
                              child: CommonComponents().printText(
                                  maxLine: 2,
                                  fontSize: 18,
                                  textData: homeController.myPlaceName.value,
                                  fontWeight:
                                      homeController.myPlaceName.value ==
                                              "Searching for you on the map.."
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                  color: homeController.myPlaceName.value ==
                                          "Searching for you on the map.."
                                      ? Colors.grey
                                      : Colors.white),
                            )),
                        Container(
                          height: 25.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: CommonComponents().printText(
                                fontSize: 15,
                                textData: "Entrance",
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                  SpaceHelper.verticalSpace15,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: GestureDetector(
                      onTap: (){
                        homeController.changingPickup.value = false;
                        homeController.polylineCoordinates.clear();
                        homeController.polyLines.clear();
                        _buildDestinationBottomSheet(context);
                      },
                      child: Container(
                        height: 38.h,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[850], // Dark grey background
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search,
                                color: Colors.grey), // Search icon
                            SpaceHelper.horizontalSpace10,
                            Expanded(
                              child: Obx(()=>CommonComponents().printText(
                                  fontSize: 15, textData: homeController.destinationPlaceName.value,
                                  fontWeight: FontWeight.w500,color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SpaceHelper.verticalSpace5,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[850], // Dark grey background
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.money_off_csred_sharp,
                              color: Colors.grey), // Search icon
                          SpaceHelper.horizontalSpace10,
                          Expanded(
                            child: TextField(
                              controller: homeController.offerPriceController,
                              onTap: () {},
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                              decoration: const InputDecoration(
                                hintText: 'MAD', // Placeholder text
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none, // No border
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            SpaceHelper.verticalSpace10,
            homeController.tripCalled.value == false &&
                    homeController.riderFound.value == true
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.money_rounded,
                          color: ColorHelper.blueColor,
                          size: 30.sp,
                        ),
                        SizedBox(
                            width: 250.w,
                            child: Obx(() => CommonComponents().commonButton(
                                  borderRadius: 13,
                                  text: homeController.tripCalled.value
                                      ? "Cancel Search"
                                      : "Find a driver",
                                  onPressed: () {
                                    if(authController.currentUser.value.phone==null)
                                      {
                                        Get.to(() => ProfileScreen(),
                                            transition: Transition.rightToLeft);
                                        homeController.showToast("Update Profile, Add your phone number");
                                      }
                                    else
                                      {
                                        if (homeController.tripCalled.value ==
                                            false) {
                                          homeController.callTrip();
                                        } else {
                                          homeController.tripCalled.value = false;
                                          PassengerRepository().removeThisTrip(
                                              homeController.tempTripId);
                                        }
                                      }

                                  },
                                ))),
                        Icon(
                          Icons.more_horiz,
                          color: ColorHelper.blueColor,
                          size: 30.sp,
                        ),
                      ],
                    ),
                  )
          ],
        ));
  }

  Widget _buildVehicleSelection() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async{
                          homeController.selectedVehicle.value = "car";
                          await homeController.loadMarkers();
                          if(homeController.destinationPlaceName!="")
                          homeController.getPolyline(travelMode: TravelMode.driving);
                        },
                        child: Container(
                            height: 70.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: homeController.selectedVehicle.value ==
                                        "car"
                                    ? ColorHelper.primaryColorShade
                                    : ColorHelper.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/car.png',
                                        fit: BoxFit.fill,
                                        width: 40.h,
                                        height: 35.h,
                                      ),
                                      CommonComponents().printText(
                                          fontSize: 15,
                                          textData: "Car",
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  homeController.selectedVehicle.value == "car"
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Icon(
                                            Icons.check_box_outlined,
                                            color: ColorHelper.primaryColor,
                                            size: 20.sp,
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () async{
                          homeController.selectedVehicle.value = "moto";
                         await  homeController.loadMarkers();
                          if(homeController.destinationPlaceName!="")
                          homeController.getPolyline(travelMode: TravelMode.walking);
                        },
                        child: Container(
                            height: 70.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: homeController.selectedVehicle.value ==
                                        "moto"
                                    ? ColorHelper.primaryColorShade
                                    : ColorHelper.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/bike.png',
                                        fit: BoxFit.cover,
                                        width: 40.h,
                                        height: 40.h,
                                      ),
                                      CommonComponents().printText(
                                          fontSize: 15,
                                          textData: "Moto",
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  homeController.selectedVehicle.value == "moto"
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Icon(
                                            Icons.check_box_outlined,
                                            color: ColorHelper.primaryColor,
                                            size: 20.sp,
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () async{
                          homeController.selectedVehicle.value = "cng";
                          await homeController.loadMarkers();
                          if(homeController.destinationPlaceName!="")
                          homeController.getPolyline(travelMode: TravelMode.driving);
                        },
                        child: Container(
                            height: 70.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: homeController.selectedVehicle.value ==
                                        "cng"
                                    ? ColorHelper.primaryColorShade
                                    : ColorHelper.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/taxi.png',
                                        fit: BoxFit.cover,
                                        width: 40.h,
                                        height: 40.h,
                                      ),
                                      CommonComponents().printText(
                                          fontSize: 15,
                                          textData: "Taxi",
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  homeController.selectedVehicle.value == "cng"
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Icon(
                                            Icons.check_box_outlined,
                                            color: ColorHelper.primaryColor,
                                            size: 20.sp,
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          cityToCityTripController.getCityToCityTripsForUser();
                          cityToCityTripController
                              .getCityToCityMyTripsForUser();
                          Get.to(() => CityToCityRequest(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                            height: 70.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: homeController.selectedVehicle.value ==
                                        "city to city"
                                    ? ColorHelper.primaryColorShade
                                    : ColorHelper.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/city_to_city.png',
                                        fit: BoxFit.cover,
                                        width: 40.h,
                                        height: 40.h,
                                      ),
                                      CommonComponents().printText(
                                          fontSize: 15,
                                          textData: "City to city",
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  homeController.selectedVehicle.value ==
                                          "city to city"
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Icon(
                                            Icons.check_box_outlined,
                                            color: ColorHelper.primaryColor,
                                            size: 20.sp,
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          freightTripController.getFreightTripsForUser();
                          freightTripController.getFreightMyTripsForUser();
                          Get.to(() => FreightRequestScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                            height: 55.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: homeController.selectedVehicle.value ==
                                        "freight"
                                    ? ColorHelper.primaryColorShade
                                    : ColorHelper.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/freight.png',
                                        fit: BoxFit.cover,
                                        width: 35.h,
                                        height: 25.h,
                                      ),
                                      CommonComponents().printText(
                                          fontSize: 15,
                                          textData: "Freight",
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  homeController.selectedVehicle.value ==
                                          "freight"
                                      ? Icon(
                                          Icons.check_box_outlined,
                                          color: ColorHelper.primaryColor,
                                          size: 20.sp,
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          courierTripController.getCourierTripsForUser();
                          courierTripController.getCourierMyTripsForUser();
                          Get.to(() => CourierRequestScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                            height: 55.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: homeController.selectedVehicle.value ==
                                        "courier"
                                    ? ColorHelper.primaryColorShade
                                    : ColorHelper.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/courier.png',
                                        fit: BoxFit.cover,
                                        width: 30.h,
                                        height: 25.h,
                                      ),
                                      CommonComponents().printText(
                                          fontSize: 15,
                                          textData: "Courier",
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  homeController.selectedVehicle.value ==
                                          "courier"
                                      ? Icon(
                                          Icons.check_box_outlined,
                                          color: ColorHelper.primaryColor,
                                          size: 20.sp,
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              homeController.destinationPickedCenter.value ==
                          LatLng(23.80, 90.41) ||
                      homeController.startPickedCenter.value ==
                          LatLng(23.80, 90.41)
                  ? SizedBox()
                  : _buildRentPriceView(initial: true)
            ],
          ),
        ));
  }

  void _buildDestinationBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      scrollControlDisabledMaxHeightRatio: 0.8,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600.h,
          decoration: BoxDecoration(
              color: ColorHelper.bgColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.sp),
                  topRight: Radius.circular(14.sp))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CommonComponents().printText(
                      fontSize: 18,
                      textData: "Enter Places",
                      fontWeight: FontWeight.bold),
                  SpaceHelper.verticalSpace15,

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                         Icon(Icons.circle_outlined, color: ColorHelper.blueColor),
                        SpaceHelper.horizontalSpace10,
                        Expanded(
                          child: TextField(
                            controller: homeController.pickupController,
                            onTap: (){
                              homeController.changingPickup.value=true;
                            },
                            onChanged: (value) {
                              homeController.changingPickup.value=true;
                              homeController.onSearchTextChanged(value);
                            },
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.sp),
                            decoration: const InputDecoration(
                              hintText: 'From', // Placeholder text
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none, // No border
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SpaceHelper.verticalSpace10,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        SpaceHelper.horizontalSpace10,
                        Expanded(
                          child: TextField(
                            controller: homeController.destinationController,
                            onTap: (){
                              homeController.changingPickup.value=false;
                            },
                            onChanged: (value) {
                              homeController.changingPickup.value=false;
                              homeController.onSearchTextChanged(value);
                            },
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                            decoration: const InputDecoration(
                              hintText: 'To', // Placeholder text
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none, // No border
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SpaceHelper.verticalSpace10,
                  InkWell(
                    onTap: () {
                      Get.back();
                      homeController.pickingDestination.value = true;
                      Get.to(SelectDestination(),
                          transition: Transition.rightToLeft);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 28.sp,
                          color: ColorHelper.primaryColor,
                        ),
                        SpaceHelper.horizontalSpace5,
                        CommonComponents().printText(
                            color: ColorHelper.primaryColor,
                            fontSize: 16,
                            textData: "Choose on map",
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  SpaceHelper.verticalSpace15,
                  Obx(() => SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                            itemCount: homeController.suggestions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  if(homeController.changingPickup.value)
                                    {
                                      homeController.pickupController.text =
                                      homeController.suggestions[index]
                                      ["description"];
                                      homeController.myPlaceName.value=homeController.pickupController.text;
                                      var placeDetails = await homeController
                                          .googlePlace.details
                                          .get(homeController.suggestions[index]
                                      ["placeId"]);
                                      log("LatLong: ${placeDetails!.result!.geometry!.location!.lat}");
                                      double? lat = placeDetails
                                          .result!.geometry!.location!.lat;
                                      double? lng = placeDetails
                                          .result!.geometry!.location!.lng;
                                      homeController.startPickedCenter.value =
                                          LatLng(lat!, lng!);
                                    }
                                  else
                                    {
                                      homeController.destinationController.text =
                                      homeController.suggestions[index]
                                      ["description"];
                                      homeController.destinationPlaceName.value=homeController.destinationController.text;
                                      var placeDetails = await homeController
                                          .googlePlace.details
                                          .get(homeController.suggestions[index]
                                      ["placeId"]);
                                      log("LatLong: ${placeDetails!.result!.geometry!.location!.lat}");
                                      double? lat = placeDetails
                                          .result!.geometry!.location!.lat;
                                      double? lng = placeDetails
                                          .result!.geometry!.location!.lng;
                                      homeController.destinationPickedCenter.value =
                                          LatLng(lat!, lng!);
                                    }

                                  if(homeController.myPlaceName.value!="Searching for you on the map.." && homeController.destinationPlaceName.value!="")
                                    {
                                      Get.back();
                                      homeController.getPolyline();
                                    }

                                },
                                child: ListTile(
                                    leading:
                                        const Icon(Icons.location_on_outlined),
                                    trailing: CommonComponents().printText(
                                        fontSize: 12,
                                        textData: "",
                                        fontWeight: FontWeight.bold),
                                    title: CommonComponents().printText(
                                        fontSize: 18,
                                        textData: homeController
                                            .suggestions[index]["description"],
                                        fontWeight: FontWeight.bold)),
                              );
                            }),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRentPriceView({required bool initial}) {
    return Obx(() => Container(
          height: 30.h,
          width: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.sp),
              border: Border.all(color: Colors.white)),
          child: Center(
            child: CommonComponents().printText(
                fontSize: 14,
                textData: "${homeController.minOfferPrice.value} ৳",
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}
