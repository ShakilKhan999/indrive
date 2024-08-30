import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';
import 'package:pinput/pinput.dart';

import '../../../components/common_components.dart';
import '../../../helpers/space_helper.dart';
import '../../../helpers/style_helper.dart';

class OTPVerificationPage extends StatelessWidget {
  OTPVerificationPage({super.key});
  final commonComponents = CommonComponents();

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
                      controller: _authController.pinPutController,
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: 40.w,
                        height: 40.h,
                        textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorHelper.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        _authController.otp.value = value;
                      },
                      onSubmitted: (value) async {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
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
            SpaceHelper.verticalSpace40,
            Obx(
              () => Padding(
                padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
                child: commonComponents.commonButton(
                    text: 'Submit',
                    onPressed: () async {
                      await _authController
                          .signInWithPhoneNumber(_authController.otp.value);
                    },
                    isLoading: _authController.isOtpSubmitLoading.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
