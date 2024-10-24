import 'package:callandgo/main.dart';
import 'package:callandgo/screens/courier_user/controller/courier_trip_controller.dart';
import 'package:callandgo/screens/courier_user/views/courier_request_for_rider.dart';
import 'package:callandgo/screens/driver/courier/views/courier_types_screen.dart';
import 'package:callandgo/screens/driver/driver_home/controller/driver_home_controller.dart';
import 'package:callandgo/screens/profile/controller/profile_controller.dart';
import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/profile/views/choose_profile_screen.dart';

import '../screens/city_to_city_user/controller/city_to_city_trip_controller.dart';
import '../screens/city_to_city_user/views/driver_city_to_city_request_list.dart';
import '../screens/drawer_screen/my_ride_screen.dart';
import '../screens/driver/city_to_city/views/cityToCity_types_screen.dart';
import '../screens/driver/freight/views/freight_info_screen.dart';
import '../screens/freight_user/controller/freight_trip_controller.dart';
import '../screens/freight_user/view/freight_request_for_rider.dart';
import '../screens/profile/views/profile_screen.dart';
import '../utils/global_toast_service.dart';

class CustomDrawerForDriver extends StatelessWidget {
  CustomDrawerForDriver({super.key});
  final AuthController _authController = Get.find();
  final ProfileController _profileController = Get.put(ProfileController());
  final DriverHomeController _driverHomeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: ColorHelper.bgColor,
        child: Column(
          children: [
            _buildProfileView(),
            _buildDrawerItemView(),
            const Spacer(),
            _buildBottomView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomView(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Color.fromARGB(255, 70, 70, 70),
        ),
        SpaceHelper.verticalSpace5,
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: CommonComponents().commonButton(
                text: _authController.isDriverMode.value
                    ? 'Passenger mode'
                    : 'Driver mode',
                isLoading: _authController.userSwitchLoading.value,
                onPressed: () {
                  _authController.switchMode();
                }),
          ),
        ),
        SpaceHelper.verticalSpace10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: CommonComponents().commonButton(
              text: 'Delete account',
              onPressed: () {
                showDeleteDialog(context);
              },
              color: ColorHelper.red),
        ),
        SpaceHelper.verticalSpace20
      ],
    );
  }

  Widget _buildDrawerItemView() {
    return Column(
      children: [
        buildDrawerItem(
          // icon: Icons.maps_home_work_sharp,
          imagePath: "assets/images/location.png",
          colorImg: ColorHelper.primaryColor,
          text: 'City Ride',
          color: Colors.white,
          onTap: () {
            AuthController authController = Get.find();
            if (!authController.checkProfile()) {
              showToast(
                  toastText: 'Please complete your profile',
                  toastColor: ColorHelper.red);
              Get.to(() => ProfileScreen(), transition: Transition.rightToLeft);
              return;
            }
            Get.back();
          },
        ),
        buildDrawerItem(
          // icon: Icons.maps_home_work_sharp,
          imagePath: "assets/images/city_to_city.png",
          text: 'City to City',
          color: Colors.white,
          onTap: () async {
            fToast.init(Get.context!);
            ProfileController _profileController = Get.put(ProfileController());
            await _profileController.getUserProfile();

            if (_profileController.cityToCityStatus.value.status ==
                'Registration completed') {
              CityToCityTripController _cityToCityTripController =
                  Get.put(CityToCityTripController());
              AuthController authController = Get.find();
              if (!authController.checkProfile()) {
                showToast(
                    toastText: 'Please complete your profile',
                    toastColor: ColorHelper.red);
                Get.to(() => ProfileScreen(),
                    transition: Transition.rightToLeft);
                return;
              }
              _cityToCityTripController.getCityToCityTrips();
              _cityToCityTripController.getCityToCityMyTrips();
              Get.to(() => DriverCityToCityRequestList(),
                  transition: Transition.rightToLeft);
            } else if (_profileController.cityToCityStatus.value.status ==
                'Not Registered') {
              Get.to(() => CitytocityTypesScreen(),
                  transition: Transition.rightToLeft);
            } else if (_profileController.cityToCityStatus.value.status ==
                'Verification pending') {
              showToast(
                  toastText: 'Documents submitted but verification pending',
                  toastColor: ColorHelper.red);
            } else if (_profileController.cityToCityStatus.value.status ==
                'Verification failed') {}
          },
        ),
        buildDrawerItem(
          // icon: Icons.fire_truck,
          imagePath: 'assets/images/freight.png',
          text: 'Freight',
          color: Colors.white,
          onTap: () async {
            fToast.init(Get.context!);
            await _profileController.getUserProfile();
            if (_profileController.freightStatus.value.status ==
                'Registration completed') {
              FreightTripController _freightTripController =
                  Get.put(FreightTripController());
              AuthController authController = Get.find();
              if (!authController.checkProfile()) {
                showToast(
                    toastText: 'Please complete your profile',
                    toastColor: ColorHelper.red);
                Get.to(() => ProfileScreen(),
                    transition: Transition.rightToLeft);
                return;
              }
              _freightTripController.getFreightTrips();
              _freightTripController.getFreightMyTrips();
              Get.to(() => FreightRequesForRider(),
                  transition: Transition.rightToLeft);
            } else if (_profileController.freightStatus.value.status ==
                'Not Registered') {
              Get.to(() => FreightInfoScreen(),
                  transition: Transition.rightToLeft);
            } else if (_profileController.freightStatus.value.status ==
                'Verification pending') {
              showToast(
                  toastText: 'Documents submitted but verification pending',
                  toastColor: ColorHelper.red);
            } else if (_profileController.freightStatus.value.status ==
                'Verification failed') {}
          },
        ),
        buildDrawerItem(
          imagePath: 'assets/images/courier.png',
          text: 'Courier',
          color: Colors.white,
          onTap: () async {
            fToast.init(Get.context!);
            await _profileController.getUserProfile();
            if (_profileController.courierStatus.value.status ==
                'Registration completed') {
              CourierTripController _courierTripController =
                  Get.put(CourierTripController());
              AuthController authController = Get.find();
              if (!authController.checkProfile()) {
                showToast(
                    toastText: 'Please complete your profile',
                    toastColor: ColorHelper.red);
                Get.to(() => ProfileScreen(),
                    transition: Transition.rightToLeft);
                return;
              }
              _courierTripController.getCourierTrips();
              _courierTripController.getCourierMyTrips();
              Get.to(() => CourierRequesForRider(),
                  transition: Transition.rightToLeft);
            } else if (_profileController.freightStatus.value.status ==
                'Not Registered') {
              Get.to(() => CourierTypsScreen(),
                  transition: Transition.rightToLeft);
            } else if (_profileController.freightStatus.value.status ==
                'Verification pending') {
              showToast(
                  toastText: 'Documents submitted but verification pending',
                  toastColor: ColorHelper.red);
            } else if (_profileController.freightStatus.value.status ==
                'Verification failed') {}
          },
        ),
        buildDrawerItem(
          icon: Icons.timer_outlined,
          text: 'Request history',
          color: Colors.white,
          onTap: () {
            // Get.back();
            _driverHomeController.getPrevTrips();
            Get.to(() => MyRideScreen(), transition: Transition.rightToLeft);
          },
        ),
        // buildDrawerItem(
        //   icon: Icons.safety_check,
        //   text: 'Safety',
        //   color: Colors.white,
        //   onTap: () {
        //     // Get.offAll(() =>
        //     //     transition: Transition.rightToLeft);
        //   },
        // ),
        buildDrawerItem(
          // icon: Icons.logout_rounded,
          imagePath: 'assets/images/logout.png',
          text: 'Logout',
          color: Colors.white,
          onTap: () {
            _authController.signOut();
          },
        ),
      ],
    );
  }

  Widget _buildProfileView() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _profileController.getUserProfile();
            Get.to(() => ChooseProfileScreen(),
                transition: Transition.rightToLeft);
          },
          child: Container(
            // height: 60.h,
            padding: EdgeInsets.fromLTRB(0, 6.h, 0, 6.h),
            color: const Color.fromARGB(255, 70, 70, 70),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
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
                      ),
                      SpaceHelper.horizontalSpace5,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: SizedBox(
                                width: 150.w,
                                child: Text(
                                  _authController.currentUser.value.name!,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          SpaceHelper.verticalSpace3,
                         Obx(()=> FivePointedStar(
                           count: _authController.myRating.value.floor(),
                           onChange: (count) {},
                           disabled: true,
                         ))
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ListTile buildDrawerItem({
    IconData? icon,
    String? imagePath,
    required String text,
    Color? color,
    Color? colorImg,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: ColorHelper.whiteColor,
            )
          : (imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 28.w,
                  height: 28.h,
                  color: colorImg,
                )
              : null),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorHelper.bgColor,
          title: CommonComponents().printText(
              fontSize: 12,
              textData: 'Delete accpunt',
              fontWeight: FontWeight.bold),
          content: CommonComponents().printText(
              fontSize: 12,
              textData: 'Are you sure you want to delete this item?',
              fontWeight: FontWeight.bold),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: CommonComponents().printText(
                    fontSize: 12,
                    textData: 'Cancel',
                    fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: CommonComponents().printText(
                    fontSize: 12,
                    textData: 'Delete',
                    fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }
}
