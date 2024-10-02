import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/driver/driver_home/controller/driver_home_controller.dart';
import 'package:callandgo/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:get/get.dart';

import '../home/views/list_map.dart';

class MyRideScreen extends StatelessWidget {
  MyRideScreen({super.key});
  final AuthController authController = Get.find();
  final DriverHomeController driverHomeController =
      Get.put(DriverHomeController());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        appBar: SimpleAppbar(titleText: 'History'),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 20.h),
          child: Column(
            children: [
              // _buidHeadertextView(),
              // SpaceHelper.verticalSpace15,
              Obx(() => _buildListView(authController.isDriverMode.value
                  ? driverHomeController.previousTrips
                  : homeController.previousTrips))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(var rideList) {
    return Expanded(
      child: ListView.builder(
        itemCount: rideList.length,
        itemBuilder: (context, index) {
          final ride = rideList[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: ColorHelper.lightGreyColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceHelper.verticalSpace15,
                  // Conditional rendering of Map or Text
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: ColorHelper.primaryColor,
                    ),
                    child: ride.polyLineEncoded == null ||
                            ride.polyLineEncoded!.isEmpty
                        ? Center(
                            child: Text(
                              "Route not available ",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : MapWidget(polyLineEncoded: ride.polyLineEncoded!),
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                    fontSize: 16,
                    textData: ride.destination!,
                    fontWeight: FontWeight.bold,
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                    fontSize: 14,
                    textData:
                        ride.dropped ? "Ride Completed" : "Ride Cancelled",
                    fontWeight: FontWeight.w500,
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                    fontSize: 14,
                    textData: ride.rent.toString() + " \$",
                    fontWeight: FontWeight.w500,
                  ),
                  SpaceHelper.verticalSpace10,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
