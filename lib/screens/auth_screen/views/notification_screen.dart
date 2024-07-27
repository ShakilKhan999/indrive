import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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

    return Padding(
      padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 20.sp),
      child: commonComponents.commonButton(
        text: 'Allow',
        onPressed: () async {
          PermissionStatus status = await Permission.notification.request();
          if (status.isGranted) {
            Get.snackbar('Permission', 'Notification permission granted');
          } else {
            Get.snackbar('Permission', 'Notification permission denied');
          }
        },
      ),
    );
  }

  Widget _buildHeadingView() {
    return Column(
      children: [
        SpaceHelper.verticalSpace40,
        Image.asset(
          'assets/images/Notification_icon.png',
          height: 150.h,
          width: 150.w,
        ),
        SpaceHelper.verticalSpace10,
        Text(
          'Do you want to allow notifications?',
          style: StyleHelper.heading,
        ),
        SpaceHelper.verticalSpace10,
        Text(
          "You won't miss offers, messages and calls from your \n driver or courier",
          textAlign: TextAlign.center,
          style: StyleHelper.regular14,
        ),
      ],
    );
  }
}
