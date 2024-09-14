import 'package:callandgo/screens/courier_user/controller/courier_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/screens/freight_user/controller/freight_trip_controller.dart';

class CourierSelectLocation extends StatelessWidget {
  CourierSelectLocation({super.key});

  final CourierTripController _courierTripController =
      Get.put(CourierTripController());

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
                    onCameraMove: _courierTripController.changingPickup.value
                        ? _courierTripController.onCameraMove
                        : _courierTripController.onCameraMoveTo,
                    onCameraIdle: _courierTripController.changingPickup.value
                        ? _courierTripController.onCameraIdle
                        : _courierTripController.onCameraIdleTo,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.terrain,
                    onMapCreated: _courierTripController.changingPickup.value
                        ? _courierTripController.onMapCreated
                        : _courierTripController.onMapCreatedTo,
                    initialCameraPosition: CameraPosition(
                      target: _courierTripController.center.value,
                      zoom: 15.0,
                    ),
                  ),
                )),
            Positioned(
                top: 30.h,
                left: 15.w,
                child: InkWell(
                  onTap: () {
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
                  child: Obx(() => _courierTripController.cameraMoving.value
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
                        Get.back();
                      },
                      disabled: _courierTripController.cameraMoving.value
                          ? true
                          : false)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
