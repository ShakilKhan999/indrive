import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:indrive/screens/auth_screen/views/user_name_screen.dart';
import 'package:indrive/screens/driver/driver_info/views/vehicle_type_screen.dart';

class UserTypeSelectScreen extends StatelessWidget {
  const UserTypeSelectScreen({super.key});

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
              Get.offAll(() => UserNameScreen(),
                  transition: Transition.rightToLeft);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
          child: commonComponents.commonButton(
            color: ColorHelper.lightGreyColor,
            text: 'Driver',
            onPressed: () {
              Get.offAll(() => VehicleScreen(),
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
