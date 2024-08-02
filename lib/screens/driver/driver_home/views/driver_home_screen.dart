import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/auth_screen/views/register_screen.dart';
import 'package:indrive/screens/driver/driver_home/controller/driver_home_controller.dart';
import 'package:indrive/screens/driver/driver_home/repository/driver_repository.dart';
import 'package:indrive/screens/home/repository/passenger_repositoy.dart';

import '../../../../components/custom_drawer.dart';

class DriverHomeScreen extends StatelessWidget {
  DriverHomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DriverHomeController driverHomeController =
      Get.put(DriverHomeController());
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
                              color: Colors.blue,
                              width: 7)
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
              width: 100.h,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(90)),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SpaceHelper.horizontalSpace5,
                  CommonComponents().printText(
                      fontSize: 18,
                      textData: "Rock",
                      fontWeight: FontWeight.bold),
                  Container(
                    height: 35.h,
                    width: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.white,
                        border: Border.all(color: Colors.white)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.network(
                        "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg",
                        height: 35.h,
                        width: 35.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
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
          )
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
                CommonComponents().printText(
                    fontSize: 18,
                    textData: driverHomeController.activeCall[0].destination,
                    fontWeight: FontWeight.normal),
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
                      await PassengerRepository().callDriver(
                          driverHomeController.activeCall[0].tripId, "");
                      driverHomeController.polyLines.clear();
                      driverHomeController.polylineCoordinates.clear();
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
                CommonComponents().printText(
                    fontSize: 18,
                    textData: driverHomeController.activeCall[0].destination,
                    fontWeight: FontWeight.normal),
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
                    text: "Call",
                    onPressed: () async {},
                    color: Colors.blue,
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
                    },
                    color: Colors.green,
                    borderRadius: 14))
          ],
        ),
      ],
    );
  }
}
