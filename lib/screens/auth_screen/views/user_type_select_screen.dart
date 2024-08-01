import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';

class UserTypeSelectScreen extends StatelessWidget {
   UserTypeSelectScreen({super.key});
  final AuthController _authController = Get.find();
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
            text: "Passenger",
            onPressed: () {

              _authController.onPressPassenger();
              
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
          child: commonComponents.commonButton(
            color: ColorHelper.lightGreyColor,
            text: 'Driver',
            onPressed: () {
              _authController.onPressDriver();
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
        Text(
          'Are you a passenger or a driver',
          style: StyleHelper.heading,
        ),
        SpaceHelper.verticalSpace10,
        Text(
          'You can change the mode later',
          style: StyleHelper.regular14,
        ),
        SpaceHelper.verticalSpace40,
        Image.asset(
          'assets/images/Categori_logo.png',
          height: 200.h,
          width: 300.w,
        ),
      ],
    );
  }
}
