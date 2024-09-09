import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/screens/city_to_city_user/controller/city_to_city_trip_controller.dart';


class CityToCitySelectLocation extends StatelessWidget {
  CityToCitySelectLocation({super.key});

  final CityToCityTripController cityToCityRequestController =
      Get.put(CityToCityTripController());

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
                    onCameraMove:
                        cityToCityRequestController.changingPickup.value
                            ? cityToCityRequestController.onCameraMove
                            : cityToCityRequestController.onCameraMoveTo,
                    onCameraIdle:
                        cityToCityRequestController.changingPickup.value
                            ? cityToCityRequestController.onCameraIdle
                            : cityToCityRequestController.onCameraIdleTo,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.terrain,
                    onMapCreated:
                        cityToCityRequestController.changingPickup.value
                            ? cityToCityRequestController.onMapCreated
                            : cityToCityRequestController.onMapCreatedTo,
                    initialCameraPosition: CameraPosition(
                      target: cityToCityRequestController.center.value,
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
                  child: Obx(() =>
                      cityToCityRequestController.cameraMoving.value
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
                      disabled: cityToCityRequestController.cameraMoving.value
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
