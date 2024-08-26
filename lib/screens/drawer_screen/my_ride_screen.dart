import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';

class MyRideScreen extends StatelessWidget {
  const MyRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 20.h),
          child: Column(
            children: [
              _buidHeadertextView(),
              SpaceHelper.verticalSpace15,
              _buildListView()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    List<Map<String, String>> rideHistory = [
      {
        "mapImage": "Map Image",
        "placeName": "Place Name",
        "time": "Time",
        "cost": "Cost",
      },
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: rideHistory.length,
        itemBuilder: (context, index) {
          final ride = rideHistory[index];
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
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Colors.red,
                    ),
                    child: Center(child: Text(ride["mapImage"]!)),
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                      fontSize: 16,
                      textData: ride["placeName"]!,
                      fontWeight: FontWeight.bold),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                      fontSize: 14,
                      textData: ride["time"]!,
                      fontWeight: FontWeight.w500),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                      fontSize: 14,
                      textData: ride["cost"]!,
                      fontWeight: FontWeight.w500),
                  SpaceHelper.verticalSpace10,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buidHeadertextView() {
    return CommonComponents().printText(
        fontSize: 26, textData: 'History', fontWeight: FontWeight.w600);
  }
}
