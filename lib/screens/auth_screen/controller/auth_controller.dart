import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/shared_preference_helper.dart';

import 'package:indrive/models/user_model.dart';
import 'package:indrive/screens/auth_screen/repository/auth_repository.dart';
import 'package:indrive/screens/auth_screen/views/register_screen.dart';
import 'package:indrive/utils/firebase_option.dart';
import 'package:indrive/utils/global_toast_service.dart';
import 'package:indrive/utils/shared_preference_keys.dart';
import '../../home_screen/views/passenger_home.dart';
import '../views/location_permission_screeen.dart';

class AuthController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkCurrentUser();
  }

  var emailController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var confirmPassController = TextEditingController().obs;
  var searchController = TextEditingController().obs;

  var obscureText = true.obs;
  var confirmObscureText = true.obs;
  var isRemember = true.obs;
  var isAgree = true.obs;
  var otpSubmitted = false.obs;
  var otpTime = '02:30'.obs;
  final TextEditingController phoneNumbercontroller = TextEditingController();
  final TextEditingController pinPutController = TextEditingController();
  var countryCode = '880'.obs;
  String verificationCode = "";
  int resendforceToken = 0;
  var locations =
      ['Dhaka (ঢাকা)', 'Gazipur City', 'Chittagong', 'Sylhet', 'Khulna'].obs;
  var selectedLocation = 'Dhaka (ঢাকা)'.obs;

  checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Timer(
        const Duration(milliseconds: 500),
        () {
          Get.offAll(() => PassengerHomeScreen());
        },
      );
    }
  }

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

  Future<UserInfo?> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    UserInfo? user;
    final auth = FirebaseAuth.instance;
    if (Platform.isAndroid) {
      googleSignIn = GoogleSignIn();
    } else if (Platform.isIOS) {
      googleSignIn = GoogleSignIn(
          clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);
    }

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user?.providerData[0];
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          showToast(
              toastText: 'Account exists with different credential',
              toastColor: ColorHelper.red);
        } else if (e.code == 'invalid-credential') {
          showToast(
              toastText: 'Invalid credential', toastColor: ColorHelper.red);
        }
      } catch (e) {
        showToast(
            toastText: 'Something went wrong. Please try again later',
            toastColor: ColorHelper.red);
        log('Error while sing in with google: $e');
      }
    }
    return user;
  }

  Future<UserInfo?> signInWithPhoneNumber(String otp) async {
    UserInfo? user;
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: otp,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user?.providerData[0];
      assert(user?.uid == user!.uid);
      Get.to(() => const LocationPermissionScreen());
    } catch (e) {
      showToast(
          toastText: 'Something went wrong. Please try again later',
          toastColor: ColorHelper.red);
      log('Error while sing in with phone: $e');
    }
    return user;
  }

  void verifyPhoneNumber({bool isResend = false}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    verificationFailed(FirebaseAuthException authException) {}

    codeSent(String verificationId, int? forceToken) async {
      showToast(
          toastText: 'Please check your phone for the verification code.',
          toastColor: ColorHelper.red);
      verificationCode = verificationId;
      resendforceToken = forceToken!;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      verificationCode = verificationId;
    }

    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {}

    if (isResend) {
      await auth
          .verifyPhoneNumber(
              phoneNumber:
                  '+${countryCode.value}${phoneNumbercontroller.value.text}',
              timeout: const Duration(seconds: 10),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent,
              forceResendingToken: resendforceToken,
              codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
          .then((value) {})
          .catchError((onError) {
        log('Error while sending otp $onError');
      });
    } else {
      await auth
          .verifyPhoneNumber(
              phoneNumber:
                  '+${countryCode.value}${phoneNumbercontroller.value.text}',
              timeout: const Duration(seconds: 10),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent,
              codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
          .then((value) {})
          .catchError((onError) {
        log('Error while sending otp $onError');
      });
    }
  }

  Future saveUserData(
      {required UserInfo userInfo, required String loginType}) async {
    try {
      UserModel? userModel;
      if (loginType == 'phone') {
        userModel = UserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          name: nameController.value.text,
          phone: '+${countryCode.value}${phoneNumbercontroller.value.text}',
          signInWith: 'phone',
        );
      } else {
        userModel = UserModel(
          uid: userInfo.uid,
          name: userInfo.displayName,
          email: userInfo.email,
          photo: userInfo.photoURL,
          phone: userInfo.phoneNumber,
          signInWith: 'google',
        );
      }
      var response = await AuthRepository().saveUserData(userModel: userModel);
      if (response) {
        await setLoginType(type: loginType);
        Get.offAll(() => PassengerHomeScreen());
      } else {
        showToast(
            toastText: 'Something went wrong. Please try again later',
            toastColor: ColorHelper.red);
      }
    } catch (e) {
      showToast(
          toastText: 'Something went wrong. Please try again later',
          toastColor: ColorHelper.red);
    }
  }

  Future setLoginType({required String type}) async {
    await SharedPreferenceHelper()
        .setString(key: SharedPreferenceKeys.loginType, value: type);
  }

  googleSignOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => RegisterScreen());
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => RegisterScreen());
  }
}
