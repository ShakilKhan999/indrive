import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/common_button.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/helpers/style_helper.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:indrive/screens/auth_screen/views/location_permission_screeen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:pinput/pinput.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final AuthController _authController = Get.put(AuthController());
  final commonComponents = CommonComponents();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(),
          SpaceHelper.verticalSpace10,
          Obx(() => _authController.otpSubmitted.value
              ? _buildOTPVerification(context)
              : _buildPhoneTextFiled(context)),
        ],
      ),
    );
  }

  Widget _buildGoogleSignIn() {
    return Column(
      children: [
        Text(
          'Or login with',
          style: StyleHelper.regular14,
        ),
        SpaceHelper.verticalSpace20,
        // Padding(
        //   padding: EdgeInsets.fromLTRB(0.sp, 0.sp, 0.sp, 30.sp),
        //   child: commonComponents.CommonButton(
        //     text: 'Continue with Google',
        //     imagePath: 'assets/images/Google_logo.png',height: 25.h,
        //       width: 25.w,
        //     onPressed: () {
        //       _authController.otpSubmitted.value = true;
        //       _authController.startOtpCountdown();
        //     },
        //   ),
        // ),
        CommonButton(
            onTap: () async {
              UserInfo? userInfo = await _authController.signInWithGoogle();
              await _authController.saveUserData(userInfo: userInfo!);
            },
            text: 'Continue with Google',
            color: const Color.fromARGB(255, 123, 122, 122),
            icon: Image.asset(
              'assets/images/Google_logo.png',
              height: 25.h,
              width: 25.w,
            )),
      ],
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
              child:
                  // InternationalPhoneNumberInput(
                  //   textFieldController: _authController.phoneNumbercontroller,
                  //   onInputValidated: (bool value) {
                  //     if (kDebugMode) {
                  //       print(value);
                  //     }
                  //   },
                  //   selectorConfig: const SelectorConfig(
                  //     selectorType: PhoneInputSelectorType.DROPDOWN,
                  //     showFlags: true,
                  //     useBottomSheetSafeArea: false,
                  //     useEmoji: true,
                  //     leadingPadding: 0.0,
                  //     setSelectorButtonAsPrefixIcon: false,
                  //     trailingSpace: false,
                  //   ),
                  //   ignoreBlank: false,
                  //   cursorColor: Colors.grey,
                  //   autoValidateMode: AutovalidateMode.disabled,
                  //   selectorTextStyle: StyleHelper.regular14,
                  //   formatInput: true,
                  //   keyboardType: const TextInputType.numberWithOptions(
                  //     signed: true,
                  //     decimal: true,
                  //   ),
                  //   inputDecoration: InputDecoration(
                  //     // label: Text('Phone Number'),
                  //     hintText: 'Phone number',
                  //     hintStyle: const TextStyle(
                  //       color: Colors.grey,
                  //     ),

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10.r),
                  //       borderSide: const BorderSide(
                  //         color: Colors.grey,
                  //         width: 1.0,
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10.r),
                  //       borderSide: const BorderSide(
                  //         color: Colors.blue,
                  //         width: 2.0,
                  //       ),
                  //     ),
                  //   ),
                  //   onSaved: (PhoneNumber number) {
                  //     if (kDebugMode) {
                  //       print('On Saved: $number');
                  //     }
                  //   },
                  //   onInputChanged: (PhoneNumber value) {},
                  // ),
                  IntlPhoneField(
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
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                initialCountryCode: 'BD',
                onChanged: (phone) {
                  // print(phone.completeNumber);
                },
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
                _authController.otpSubmitted.value = true;
                _authController.startOtpCountdown();
              },
            ),
          ),
          // CommonButton(
          //   onTap: () {
          //     _authController.otpSubmitted.value = true;
          //     _authController.startOtpCountdown();
          //   },
          //   text: 'Get OTP',
          //   color: ColorHelper.primaryColor,
          //   icon: Icon(
          //     Icons.send,
          //     color: Colors.white,
          //     size: 25.sp,
          //   ),
          // ),
          SpaceHelper.verticalSpace20,
          _buildGoogleSignIn()
        ],
      ),
    );
  }

  Widget _buildOTPVerification(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OTP Verification',
            style: StyleHelper.regular14,
          ),
          SpaceHelper.verticalSpace10,
          Text.rich(
            style: StyleHelper.regular14,
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Enter the code from the sms we sent to ',
                ),
                TextSpan(
                  text: '${_authController.phoneNumbercontroller.text} ',
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SpaceHelper.verticalSpace30,
          SpaceHelper.verticalSpace10,
          SizedBox(
              height: 100.h,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Obx(() => Text(
                        _authController.otpTime.value,
                        style: StyleHelper.regular14,
                      )),
                  SpaceHelper.verticalSpace10,
                  Pinput(
                    defaultPinTheme: PinTheme(
                      width: 40.w,
                      height: 40.h,
                      textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SpaceHelper.verticalSpace10,
                  Text.rich(
                    TextSpan(
                      style: StyleHelper.regular14,
                      children: const [
                        TextSpan(
                          text: "Don't receive the ",
                        ),
                        TextSpan(
                          text: 'OTP? ',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              )),
          SpaceHelper.verticalSpace60,
          SpaceHelper.verticalSpace10,
          Padding(
            padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
            child: commonComponents.commonButton(
              text: 'Submit',
              onPressed: () {
                Get.offAll(() => const LocationPermissionScreen(),
                    transition: Transition.rightToLeft);
              },
            ),
          ),
          // CommonButton(
          //   onTap: () {
          //     Get.offAll(() => const LocationPermissionScreen(),
          //         transition: Transition.rightToLeft);
          //   },
          //   text: 'Submit',
          //   color: ColorHelper.primaryColor,
          // )
        ],
      ),
    );
  }

  Widget _buildHeader() =>
      Text('Join us via phone number', style: StyleHelper.heading);
}
   // Get.offAll(() => const HomeScreen(),
              //     transition: Transition.rightToLeft);