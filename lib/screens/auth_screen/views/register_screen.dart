import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/common_button.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/helpers/style_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/auth_screen/views/otp_verification.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final AuthController _authController = Get.put(AuthController());
  final commonComponents = CommonComponents();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: Obx(
        () => _authController.isCheckingCurrentUser.value
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorHelper.whiteColor,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  SpaceHelper.verticalSpace10,
                  _buildPhoneTextFiled(context),
                ],
              ),
      ),
    );
  }

  Widget _buildGoogleSignIn() {
    return Obx(
      () => Column(
        children: [
          Text(
            'Or login with',
            style: StyleHelper.regular14,
          ),
          SpaceHelper.verticalSpace20,
          CommonButton(
            onTap: () async {
              _authController.loginType.value = 'google';
              // _authController.signOut();
              
              // await FirebaseAuth.instance.signOut();

              await _authController.signInWithGoogle();
            },
            text: 'Continue with Google',
            color: const Color.fromARGB(255, 123, 122, 122),
            icon: Image.asset(
              'assets/images/Google_logo.png',
              height: 25.h,
              width: 25.w,
            ),
            isLoading: _authController.isGoogleSigninLoaidng.value,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTextFiled(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter mobile no.*',
            style: StyleHelper.heading,
          ),
          SpaceHelper.verticalSpace10,
          SizedBox(
              height: 60.h,
              width: MediaQuery.of(context).size.width,
              child: IntlPhoneField(
                controller: _authController.phoneNumbercontroller,
                cursorColor: Colors.grey,
                style: StyleHelper.regular14,
                dropdownTextStyle: const TextStyle(color: Colors.grey),
                dropdownIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorHelper.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                initialCountryCode: 'BD',
                onCountryChanged: (value) {
                  log(value.dialCode);
                  _authController.countryCode.value = value.dialCode;
                },
                onChanged: (phone) {},
              )),
          SpaceHelper.verticalSpace60,
          Padding(
            padding: EdgeInsets.fromLTRB(0.sp, 0.sp, 0.sp, 0.sp),
            child: commonComponents.commonButton(
              text: 'Get OTP',
              icon: Icon(
                Icons.send,
                color: Colors.white,
                size: 25.sp,
              ),
              onPressed: () {
                _authController.loginType.value = 'phone';
                _authController.startOtpCountdown();
                _authController.verifyPhoneNumber();
                Get.to(() => OTPVerificationPage(),
                    transition: Transition.rightToLeft);
              },
            ),
          ),
          SpaceHelper.verticalSpace20,
          _buildGoogleSignIn()
        ],
      ),
    );
  }

  Widget _buildHeader() =>
      Text('Join us via phone number', style: StyleHelper.heading);
}
