import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/drawer_screen/my_ride_screen.dart';
import 'package:indrive/screens/freight_user/view/freight_request_screen.dart';
import 'package:indrive/screens/home/views/passenger_home.dart';
import 'package:indrive/screens/profile/views/choose_profile_screen.dart';

import '../screens/city_to_city_user/views/city_to_city_request.dart';
import '../screens/driver/courier/views/courier_screen.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final AuthController _authController = Get.find();

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
                text: _authController.isDriver.value
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
              color: const Color.fromARGB(255, 161, 9, 9)),
        ),
        SpaceHelper.verticalSpace20
      ],
    );
  }

  Widget _buildDrawerItemView() {
    return Column(
      children: [
        buildDrawerItem(
          icon: Icons.maps_home_work_sharp,
          text: 'City',
          color: Colors.white,
          onTap: () {
            Get.offAll(() => PassengerHomeScreen(),
                transition: Transition.noTransition);
          },
        ),
        buildDrawerItem(
          icon: Icons.maps_home_work_sharp,
          text: 'City to City',
          color: Colors.white,
          onTap: () {
            // Get.back();
            Get.to(() => CityToCityRequest(),
                transition: Transition.rightToLeft);
          },
        ),
        buildDrawerItem(
          icon: Icons.fire_truck,
          text: 'Freight',
          color: Colors.white,
          onTap: () {
            // Get.back();
            Get.to(() => FreightRequestScreen(), transition: Transition.rightToLeft);
          },
        ),
        buildDrawerItem(
          icon: Icons.fire_truck,
          text: 'Courier',
          color: Colors.white,
          onTap: () {
            // Get.back();
            Get.to(() => CourierScreen(), transition: Transition.rightToLeft);
          },
        ),
        buildDrawerItem(
          icon: Icons.timer_outlined,
          text: 'Request history',
          color: Colors.white,
          onTap: () {
            Get.back();
            Get.to(() => MyRideScreen(), transition: Transition.rightToLeft);
          },
        ),
        buildDrawerItem(
          icon: Icons.safety_check,
          text: 'Safety',
          color: Colors.white,
          onTap: () {
            // Get.offAll(() =>
            //     transition: Transition.rightToLeft);
          },
        ),
        buildDrawerItem(
          icon: Icons.logout_rounded,
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
                          FivePointedStar(
                            count: 5,
                            onChange: (count) {},
                            disabled: true,
                          )
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

  ListTile buildDrawerItem(
      {required IconData icon,
      required String text,
      Color? color,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: ColorHelper.whiteColor,
      ),
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
