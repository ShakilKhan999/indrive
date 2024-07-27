import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/models/user_model.dart';
import 'package:indrive/screens/auth_screen/repository/auth_repository.dart';
import 'package:indrive/screens/auth_screen/views/register_screen.dart';
import 'package:indrive/screens/home_screen/views/home_screen.dart';
import 'package:indrive/utils/firebase_option.dart';
import 'package:indrive/utils/global_toast_service.dart';

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
  var obscureText = true.obs;
  var confirmObscureText = true.obs;
  var isRemember = true.obs;
  var isAgree = true.obs;
  var otpSubmitted = false.obs;
  var otpTime = '02:30'.obs;
  final TextEditingController phoneNumbercontroller = TextEditingController();

  checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Timer(
        const Duration(milliseconds: 500),
        () {
          Get.offAll(() => HomeScreen());
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
      }
    }
    return user;
  }

  Future saveUserData({required UserInfo userInfo}) async {
    try {
      UserModel userModel = UserModel(
        uid: userInfo.uid,
        name: userInfo.displayName,
        email: userInfo.email,
        photo: userInfo.photoURL,
      );
      var response = await AuthRepository().saveUserData(userModel: userModel);
      if (response) {
        Get.offAll(() => HomeScreen());
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

  googleSignOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => RegisterScreen());
  }
}
