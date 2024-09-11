import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/driver/driver_home/controller/driver_home_controller.dart';
import 'package:indrive/screens/driver/driver_home/repository/driver_repository.dart';
import 'package:indrive/screens/home/repository/passenger_repositoy.dart';
import 'package:indrive/screens/profile/views/profile_screen.dart';

import '../../../../components/custom_drawer.dart';

class DriverHomeScreen extends StatelessWidget {
  DriverHomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DriverHomeController driverHomeController =
      Get.put(DriverHomeController());
  final AuthController _authController = Get.find();
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
      ),
      body: Center(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Obx(() => SizedBox(
                height: MediaQuery.of(context).size.height -
                    (driverHomeController.activeCall.isNotEmpty ? 140.h : 90.h),
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  polylines: driverHomeController
                          .polylineCoordinates.value.isEmpty
                      ? {}
                      : {
                          Polyline(
                              polylineId: const PolylineId("route"),
                              points: driverHomeController
                                  .polylineCoordinates.value
                                  .map((geoPoint) => LatLng(
                                      geoPoint.latitude, geoPoint.longitude))
                                  .toList(),
                              color: Colors.deepPurpleAccent,
                              width: 5)
                        },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: driverHomeController.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: driverHomeController.center.value,
                    zoom: 15.0,
                  ),
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Obx(() => driverHomeController.userLocationPicking.value
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
          Positioned(
            top: 30.h,
            left: 10.w,
            child: Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(90)),
              child: Center(
                child: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.h,
            right: 10.w,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(90)),
              child: Center(
                  child: Obx(
                () => InkWell(
                  onTap: () {
                    Get.to(() => ProfileScreen(),
                        transition: Transition.rightToLeft);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpaceHelper.horizontalSpace10,
                      CommonComponents().printText(
                          fontSize: 16,
                          textData:
                              _authController.currentUser.value.name != null
                                  ? "${_authController.currentUser.value.name!}"
                                  : "User Name",
                          fontWeight: FontWeight.bold),
                      SpaceHelper.horizontalSpace5,
                      Container(
                        height: 35.h,
                        width: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: Colors.white,
                            border: Border.all(color: Colors.white)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: _authController.currentUser.value.photo != null
                              ? Image.network(
                                  _authController.currentUser.value.photo!,
                                  height: 35.h,
                                  width: 35.h,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/person.jpg",
                                  height: 35.h,
                                  width: 35.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => AnimatedContainer(
                  duration: const Duration(microseconds: 200),
                  height: driverHomeController.activeCall.isNotEmpty
                      ? 160.h
                      : 100.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorHelper.bgColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.sp),
                          topRight: Radius.circular(20.sp))),
                  child: Center(
                    child: driverHomeController.activeCall.isEmpty
                        ? CommonComponents().printText(
                            fontSize: 20,
                            textData: "Waiting for the call..",
                            fontWeight: FontWeight.bold)
                        : driverHomeController.activeCall[0].accepted
                            ? _buildPickactions()
                            : _buildcallactions(),
                  ),
                )),
          ),
          Align(
              alignment: Alignment.center,
              child: Obx(() => driverHomeController.myActiveTrips.isEmpty
                  ? SizedBox()
                  : Container(
                      width: 300.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorHelper.blackColor.withOpacity(0.9)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: driverHomeController.myActiveTrips.length,
                        itemBuilder: (BuildContext context, int index) {
                          var bid = driverHomeController.myActiveTrips[index];

                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60.h,
                                    width: 300.w,
                                    child: bid.bids.any((mybid) =>
                                            mybid.driverId ==
                                                "I54BCk2Qa3NNMpVMytnMofUiSzy1" &&
                                            mybid.offerPrice != null)
                                        ? Center(
                                            child: CommonComponents().printText(
                                                fontSize: 14,
                                                textData:
                                                    "Waiting for user action",
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Column(
                                            children: [
                                              CommonComponents().printText(
                                                  fontSize: 12,
                                                  textData:
                                                      "To: " + bid.destination,
                                                  fontWeight: FontWeight.bold),
                                              SpaceHelper.verticalSpace5,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    child: SizedBox(
                                                      height: 30.h,
                                                      width: 50.w,
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15.sp),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Offered ${bid.rent.toString()}",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          border: InputBorder
                                                              .none, // No border
                                                        ),
                                                        controller:
                                                            driverHomeController
                                                                .offerPriceController,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        DriverRepository().offerRent(
                                                            tripId: bid.tripId,
                                                            driverId:
                                                                "I54BCk2Qa3NNMpVMytnMofUiSzy1",
                                                            rent: double.parse(
                                                                driverHomeController
                                                                    .offerPriceController
                                                                    .text));
                                                      },
                                                      icon: Icon(
                                                        Icons.send,
                                                        color: Colors.green,
                                                      )),
                                                  CommonComponents()
                                                      .commonButton(
                                                          text: "Accept",
                                                          onPressed: () async{
                                                            await DriverRepository()
                                                                .AcceptTrip(
                                                                    bid.tripId,
                                                                    "I54BCk2Qa3NNMpVMytnMofUiSzy1",
                                                                    bid.rent);
                                                            driverHomeController
                                                                .listenCall();
                                                            driverHomeController.getPolyline(picking: true);
                                                          })
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                  Divider()
                                ],
                              ));
                        },
                      ),
                    ))),
        ],
      )),
    );
  }

  Widget _buildcallactions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40.h,
          width: 300.w,
          decoration: BoxDecoration(
              color: ColorHelper.lightGreyColor,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonComponents().printText(
                    fontSize: 18, textData: "To:", fontWeight: FontWeight.bold),
                SpaceHelper.horizontalSpace10,
                SizedBox(
                  width: 210.w,
                  child: CommonComponents().printText(
                      fontSize: 18,
                      textData: driverHomeController.activeCall[0].destination,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        SpaceHelper.verticalSpace10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 40.h,
                child: CommonComponents().commonButton(
                    text: "Decline",
                    onPressed: () async {
                      // await PassengerRepository().callDriver(
                      //     driverHomeController.activeCall[0].tripId, "");
                      // driverHomeController.polyLines.clear();
                      // driverHomeController.polylineCoordinates.clear();
                    },
                    color: Colors.red,
                    borderRadius: 14)),
            SpaceHelper.horizontalSpace10,
            SizedBox(
                height: 40.h,
                child: CommonComponents().commonButton(
                    text: "Accept",
                    onPressed: () async {
                      DriverRepository().updateTripState(
                          driverHomeController.activeCall[0].tripId,
                          "accepted",
                          true);
                      driverHomeController.getPolyline(picking: true);
                    },
                    color: Colors.green,
                    borderRadius: 14))
          ],
        ),
      ],
    );
  }

  Widget _buildPickactions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40.h,
          width: 300.w,
          decoration: BoxDecoration(
              color: ColorHelper.lightGreyColor,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonComponents().printText(
                    fontSize: 18, textData: "To:", fontWeight: FontWeight.bold),
                SpaceHelper.horizontalSpace10,
                SizedBox(
                  width: 210.w,
                  child: CommonComponents().printText(
                      fontSize: 18,
                      textData: driverHomeController.activeCall[0].destination,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        SpaceHelper.verticalSpace10,
        driverHomeController.activeCall[0].picked &&
                driverHomeController.activeCall[0].dropped == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Cancel",
                          onPressed: () async {
                            DriverRepository().updateTripState(
                                driverHomeController.activeCall[0].tripId,
                                "driverCancel",
                                true);
                            DriverRepository().updateTripState(
                                driverHomeController.activeCall[0].tripId,
                                "accepted",
                                false);
                          },
                          color: Colors.red,
                          borderRadius: 14)),
                  SpaceHelper.horizontalSpace10,
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Drop and Finish",
                          onPressed: () async {
                            await DriverRepository().completeRide(
                                driverHomeController.activeCall[0].tripId,
                                driverHomeController.activeCall[0].driverId);
                            driverHomeController.activeCall.clear();
                            driverHomeController.polylineCoordinates.clear();
                            driverHomeController.polyLines.clear();
                            driverHomeController.mapController.animateCamera(
                                CameraUpdate.newLatLng(
                                    driverHomeController.center.value));
                          },
                          color: Colors.green,
                          borderRadius: 14))
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Cancel",
                          onPressed: () async {
                            DriverRepository().updateTripState(
                                driverHomeController.activeCall[0].tripId,
                                "driverCancel",
                                true);
                            DriverRepository().updateTripState(
                                driverHomeController.activeCall[0].tripId,
                                "accepted",
                                false);
                          },
                          color: Colors.red,
                          borderRadius: 14)),
                  SpaceHelper.horizontalSpace10,
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Call",
                          onPressed: () async {},
                          color: ColorHelper.primaryColor,
                          borderRadius: 14)),
                  SpaceHelper.horizontalSpace10,
                  SizedBox(
                      height: 40.h,
                      child: CommonComponents().commonButton(
                          text: "Pick",
                          onPressed: () async {
                            DriverRepository().updateTripState(
                                driverHomeController.activeCall[0].tripId,
                                "picked",
                                true);
                            driverHomeController.getPolyline(picking: false);
                          },
                          color: Colors.green,
                          borderRadius: 14))
                ],
              ),
      ],
    );
  }
}
