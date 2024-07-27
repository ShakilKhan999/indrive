import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:indrive/screens/auth_screen/views/user_type_select_screen.dart';

class ConfirmLocationScreen extends StatelessWidget {
  const ConfirmLocationScreen({super.key});

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
            text: "Yes, I'm here",
            onPressed: () {
              Get.offAll(() => const UserTypeSelectScreen(),
                  transition: Transition.rightToLeft);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
          child: commonComponents.commonButton(
            text: 'No',
            disabled: true,
            onPressed: () {
              Get.offAll(() => const UserTypeSelectScreen(),
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
          'assets/images/ConfirmLocation_logo.png',
          height: 200.h,
          width: 300.w,
        ),
        Text(
          'Are you in Dhaka?',
          style: StyleHelper.heading,
        ),
      ],
    );
  }
}
