import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/screens/home/controller/home_controller.dart';

// ignore: must_be_immutable
class SelectDestination extends StatelessWidget {
  SelectDestination({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Obx(() => SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onCameraMove: homeController.changingPickup.value
                        ? homeController.onCameraMove
                        : homeController.onCameraMoveTo,
                    onCameraIdle: homeController.changingPickup.value
                        ? homeController.onCameraIdle
                        : homeController.onCameraIdleTo,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.terrain,
                    onMapCreated: homeController.changingPickup.value
                        ? homeController.onMapCreated
                        : homeController.onMapCreatedTo,
                    initialCameraPosition: CameraPosition(
                      target: homeController.center.value,
                      zoom: 15.0,
                    ),
                  ),
                )),
            Positioned(
                top: 30.h,
                left: 15.w,
                child: InkWell(
                  onTap: () {
                    homeController.pickingDestination.value = false;
                    Get.back();
                  },
                  child: Container(
                      height: 35.h,
                      width: 35.h,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(90.sp)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25.sp,
                      )),
                )),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 32.sp),
                  child: Obx(() => homeController.cameraMoving.value
                      ? Icon(
                          Icons.pin_drop,
                          color: ColorHelper.bgColor,
                          size: 45.sp,
                        )
                      : Icon(Icons.location_on_outlined,
                          color: ColorHelper.bgColor, size: 45.sp)),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: SizedBox(
                  height: 40.h,
                  width: 150.w,
                  child: Obx(() => CommonComponents().commonButton(
                      text: "Done",
                      color: ColorHelper.blueColor,
                      borderRadius: 15,
                      onPressed: () {
                        homeController.getPolyline();
                        homeController.pickingDestination.value = false;
                        Get.back();
                      },
                      disabled:
                          homeController.cameraMoving.value ? true : false)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
