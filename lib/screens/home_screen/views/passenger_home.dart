import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/home_screen/home_controller.dart';

class PassengerHomeScreen extends StatelessWidget {
  PassengerHomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHelper.bgColor,
        centerTitle: true,
        title: Title(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonComponents().printText(
                  fontSize: 18,
                  textData: "Searching for you on the map",
                  fontWeight: FontWeight.bold),
              CommonComponents().printText(
                  fontSize: 16,
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
                    onCameraMove: homeController.onCameraMove,
                    onCameraIdle: homeController.onCameraIdle,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.terrain,
                    onMapCreated: homeController.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: homeController.center.value,
                      zoom: 15.0,
                    ),
                  ),
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
              child: Obx(() => AnimatedContainer(
                    duration: const Duration(microseconds: 200),
                    width: MediaQuery.of(context).size.width,
                    height: homeController.cameraMoving.value ? 0 : 260.h,
                    decoration: BoxDecoration(
                        color: ColorHelper.bgColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: _buildBottomView(),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomView() {
    return Column(
      children: [
        _buildVehicleSelection(),
        SpaceHelper.verticalSpace5,
        Row(
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
                      fontWeight: homeController.myPlaceName.value ==
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
        SpaceHelper.verticalSpace15,
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
                const Icon(Icons.search, color: Colors.grey), // Search icon
                SpaceHelper.horizontalSpace10,
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
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
        ),
        SpaceHelper.verticalSpace15,
        Padding(
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
                  child: CommonComponents().commonButton(
                    borderRadius: 13,
                    text: "Find a driver",
                    onPressed: () {},
                  )),
              Icon(
                Icons.more_horiz,
                color: ColorHelper.blueColor,
                size: 30.sp,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVehicleSelection() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  homeController.selectedVehicle.value = "car";
                },
                child: Container(
                    height: 55.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: homeController.selectedVehicle.value == "car"
                            ? Colors.lightBlueAccent.withOpacity(0.5)
                            : ColorHelper.bgColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/car.png',
                                fit: BoxFit.fill, // Replace with your asset
                                width: 40.h,
                                height: 22.h,
                              ),
                              CommonComponents().printText(
                                  fontSize: 15,
                                  textData: "Car",
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                          homeController.selectedVehicle.value == "car"
                              ? Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.lightBlueAccent,
                                  size: 20.sp,
                                )
                              : const SizedBox()
                        ],
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  homeController.selectedVehicle.value = "moto";
                },
                child: Container(
                    height: 55.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: homeController.selectedVehicle.value == "moto"
                            ? Colors.lightBlueAccent.withOpacity(0.5)
                            : ColorHelper.bgColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/bike.png',
                                fit: BoxFit.fill, // Replace with your asset
                                width: 40.h,
                                height: 22.h,
                              ),
                              CommonComponents().printText(
                                  fontSize: 15,
                                  textData: "Moto",
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                          homeController.selectedVehicle.value == "moto"
                              ? Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.lightBlueAccent,
                                  size: 20.sp,
                                )
                              : const SizedBox()
                        ],
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  homeController.selectedVehicle.value = "cng";
                },
                child: Container(
                    height: 55.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: homeController.selectedVehicle.value == "cng"
                            ? Colors.lightBlueAccent.withOpacity(0.5)
                            : ColorHelper.bgColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/rickshaw.png',
                                fit: BoxFit.fill, // Replace with your asset
                                width: 40.h,
                                height: 22.h,
                              ),
                              CommonComponents().printText(
                                  fontSize: 15,
                                  textData: "CNG",
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                          homeController.selectedVehicle.value == "cng"
                              ? Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.lightBlueAccent,
                                  size: 20.sp,
                                )
                              : const SizedBox()
                        ],
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
