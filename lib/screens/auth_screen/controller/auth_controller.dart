import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var emailController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var confirmPassController = TextEditingController().obs;
  var obscureText = true.obs;
  var confirmObscureText = true.obs;
  var isRemember = true.obs;
  var isAgree = true.obs;
  var otpSubmitted = false.obs;
  var otpTime = '02:30'.obs;

  final TextEditingController phoneNumbercontroller = TextEditingController();

  void startOtpCountdown() {
    Duration initialDuration = const Duration(minutes: 2, seconds: 30);
    int totalSeconds = initialDuration.inSeconds;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      otpTime.value =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      totalSeconds--;

      if (totalSeconds < 0) {
        timer.cancel();
        if (kDebugMode) {
          print('Countdown complete!');
        }
      }
    });
  }
}
