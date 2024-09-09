import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/helpers/style_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/utils/app_config.dart';

class UserNameScreen extends StatelessWidget {
  UserNameScreen({super.key});

  final AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        body: Column(
          children: [
            _buildHeaderView(),
            _buildNameTextFiledView(),
            _buildButtonView()
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderView() => Column(
        children: [
          SpaceHelper.verticalSpace40,
          Text(
            'Welcome to ${AppConfig.appName}',
            style: StyleHelper.heading,
          ),
          SpaceHelper.verticalSpace10,
          Text(
            'Please introduce youself',
            style: StyleHelper.regular14,
          ),
          SpaceHelper.verticalSpace40,
        ],
      );
  Widget _buildButtonView() {
    final commonComponents = CommonComponents();

    return Column(
      children: [
        Obx(
          () => Padding(
            padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
            child: commonComponents.commonButton(
                text: "Next",
                onPressed: () async {
                  await _authController.saveUserData(
                      userInfo:
                          FirebaseAuth.instance.currentUser!.providerData[0],
                      loginType: _authController.loginType.value);
                },
                disabled: _authController.isUserDataSaving.value,
                isLoading: _authController.isUserDataSaving.value),
          ),
        ),
      ],
    );
  }

  Widget _buildNameTextFiledView() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First Name',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SpaceHelper.verticalSpace5,
          TextField(
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none),
            controller: _authController.nameController.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            ),
          ),
          SpaceHelper.verticalSpace5,
        ],
      ),
    );
  }
}
