import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:indrive/screens/auth_screen/views/confirm_location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeadingView(),
              const Spacer(),
              _buildBottomButtonView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtonView() {
    final commonComponents = CommonComponents();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
          child: commonComponents.commonButton(
            text: 'Enable location services',
            onPressed: () async {
              PermissionStatus status = await Permission.location.request();
              if (status.isGranted) {
                Get.snackbar('Permission', 'Notification permission granted');
              } else {
                Get.snackbar('Permission', 'Notification permission denied');
              }
              Get.offAll(() => ConfirmLocationScreen(),
                  transition: Transition.rightToLeft);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
          child: commonComponents.commonButton(
            text: 'Skip',
            disabled: true,
            onPressed: () {
              Get.offAll(() => ConfirmLocationScreen(),
                  transition: Transition.rightToLeft);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeadingView() {
    return Column(
      children: [
        SpaceHelper.verticalSpace40,
        Image.asset(
          'assets/images/Location_logo.png',
          height: 300.h,
          width: 300.w,
        ),
        SpaceHelper.verticalSpace10,
        Text(
          'Turn your location on',
          style: StyleHelper.heading,
        ),
        SpaceHelper.verticalSpace10,
        Text(
          "You'll be able to find yourself on the map and drivers\n will be able to find you at the pickup point",
          textAlign: TextAlign.center,
          style: StyleHelper.regular14,
        ),
      ],
    );
  }
}
