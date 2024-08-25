import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';

import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';

import 'package:indrive/screens/driver/city_to_city/views/cityToCity_types_screen.dart';
import 'package:indrive/screens/driver/courier/views/courier_typs_screen.dart';
import 'package:indrive/screens/driver/driver_info/views/vehicle_type_screen.dart';
import 'package:indrive/screens/driver/freight/views/freight_info_screen.dart';

import 'package:indrive/screens/home/views/profile_screen.dart';

class ChooseProfileScreen extends StatelessWidget {
  ChooseProfileScreen({super.key});
  // final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      appBar: _buildAppbarView(),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          children: [
            SpaceHelper.verticalSpace10,
            _buildSelectionView(context),
            SpaceHelper.verticalSpace10,
            _buildLocationView(context)
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30.w,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonComponents().printText(
                    fontSize: 20,
                    textData: 'Do you want to make profit with us?',
                    fontWeight: FontWeight.bold),
                SpaceHelper.verticalSpace5,
                CommonComponents().printText(
                    fontSize: 16,
                    color: ColorHelper.lightGreyColor,
                    textData: 'Choose a profile and register',
                    fontWeight: FontWeight.bold),
              ],
            ),
          ),
          Container(
            height: 60.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.to(VehicleTypeScreen(),
                      transition: Transition.rightToLeft);
                },
                child: ListTile(
                  leading: SizedBox(
                      height: 30.h,
                      width: 40.h,
                      child: Image.asset("assets/images/car.png")),
                  title: CommonComponents().printText(
                      fontSize: 18,
                      textData: "Driver",
                      fontWeight: FontWeight.bold),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.to(CourierTypsScreen(),
                      transition: Transition.rightToLeft);
                },
                child: ListTile(
                  leading: SizedBox(
                      height: 30.h,
                      width: 40.h,
                      child: Image.asset("assets/images/delivery-courier.png")),
                  title: CommonComponents().printText(
                      fontSize: 18,
                      textData: "Courier",
                      fontWeight: FontWeight.bold),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.to(FreightInfoScreen(),
                      transition: Transition.rightToLeft);
                },
                child: ListTile(
                  leading: SizedBox(
                      height: 30.h,
                      width: 40.h,
                      child: Image.asset("assets/images/freight-delivery.png")),
                  title: CommonComponents().printText(
                      fontSize: 18,
                      textData: "Freight",
                      fontWeight: FontWeight.bold),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60.h,
            width: MediaQuery.of(context).size.width - 30.w,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.to(CitytocityTypesScreen(),
                      transition: Transition.rightToLeft);
                },
                child: ListTile(
                  leading: SizedBox(
                      height: 30.h,
                      width: 40.h,
                      child: Image.asset("assets/images/location.png")),
                  title: CommonComponents().printText(
                      fontSize: 18,
                      textData: "City to City",
                      fontWeight: FontWeight.bold),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30.w,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonComponents().printText(
                  fontSize: 20, textData: 'Dhaka', fontWeight: FontWeight.bold),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.location_on),
              )
            ],
          ),
          SpaceHelper.verticalSpace5,
          CommonComponents().printText(
              fontSize: 16,
              color: ColorHelper.lightGreyColor,
              textData: 'Change the city',
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  AppBar _buildAppbarView() {
    return AppBar(
      leading: Icon(Icons.arrow_back),
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(
        color: ColorHelper.whiteColor,
      ),
      title: Title(
        color: Colors.white,
        child: CommonComponents().printText(
            fontSize: 20, textData: 'Name', fontWeight: FontWeight.bold),
      ),
      backgroundColor: ColorHelper.blackColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
              onTap: () {
                Get.to(ProfileScreen(), transition: Transition.rightToLeft);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              )),
        ),
      ],
    );
  }
}
