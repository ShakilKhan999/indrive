import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/helpers/shared_preference_helper.dart';
import 'package:callandgo/models/driver_info_model.dart';

import 'package:callandgo/models/user_model.dart';
import 'package:callandgo/screens/auth_screen/repository/auth_repository.dart';
import 'package:callandgo/screens/auth_screen/views/register_screen.dart';
import 'package:callandgo/screens/auth_screen/views/user_type_select_screen.dart';
import 'package:callandgo/screens/driver/driver_home/views/driver_home_screen.dart';
import 'package:callandgo/screens/driver/driver_info/views/vehicle_type_screen.dart';
import 'package:callandgo/utils/database_collection_names.dart';
import 'package:callandgo/utils/firebase_option.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:callandgo/utils/shared_preference_keys.dart';
import '../../home/views/passenger_home.dart';
import '../views/location_permission_screeen.dart';

class AuthController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkCurrentUser();
    log('date time: ${DateTime.now().toString()}');
  }

  var nameController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var confirmPassController = TextEditingController().obs;
  var searchController = TextEditingController().obs;
  var firstnameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var fullNameController = TextEditingController().obs;
  var selectedLocation = 'Dhaka (ঢাকা)'.obs;

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

  var loginType = ''.obs;
  var currentUser = UserModel().obs;
  var userSwitchLoading = false.obs;
  var isCheckingCurrentUser = false.obs;
  var otp = ''.obs;
  var isGoogleSigninLoaidng = false.obs;
  var isOtpSubmitLoading = false.obs;
  var isUserDataSaving = false.obs;
  var isDriverMode = false.obs;

  getUserData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        currentUser.value = (await getCurrentUser())!;
        isDriverMode.value = currentUser.value.isDriverMode!;
        fullNameController.value.text = currentUser.value.name!;
        emailController.value.text = currentUser.value.email!;
      } catch (e) {
        log('Error while fethching user data: $e');
      }
    }
  }

  switchMode() async {
    try {
      userSwitchLoading.value = true;
      if (currentUser.value.isDriverMode!) {
        await MethodHelper().updateDocFields(
            docId: FirebaseAuth.instance.currentUser!.uid,
            fieldsToUpdate: {"isDriverMode": false},
            collection: userCollection);
        await getUserData();
        Get.offAll(() => PassengerHomeScreen(),
            transition: Transition.rightToLeft);
        userSwitchLoading.value = false;
      } else {
        await MethodHelper().updateDocFields(
            docId: FirebaseAuth.instance.currentUser!.uid,
            fieldsToUpdate: {"isDriverMode": true},
            collection: userCollection);
        userSwitchLoading.value = false;
        Get.offAll(() => DriverHomeScreen(),
            transition: Transition.rightToLeft);
      }
    } catch (e) {
      userSwitchLoading.value = false;
    }
  }

  checkCurrentUser() async {
    try {
      isCheckingCurrentUser.value = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Timer(
          const Duration(milliseconds: 500),
          () async {
            UserModel? userModel = await getCurrentUser();
            currentUser.value = userModel!;
            if (userModel.isDriverMode!) {
              await MethodHelper()
                  .listerUserData(
                      userId: FirebaseAuth.instance.currentUser!.uid)
                  .listen(
                (userData) {
                  currentUser.value = userData;
                },
              );
              Get.offAll(() => DriverHomeScreen(),
                  transition: Transition.rightToLeft);
              isCheckingCurrentUser.value = false;
            } else {
              await MethodHelper()
                  .listerUserData(
                      userId: FirebaseAuth.instance.currentUser!.uid)
                  .listen(
                (userData) {
                  currentUser.value = userData;
                },
              );
              Get.offAll(() => const PassengerHomeScreen(),
                  transition: Transition.rightToLeft);
              isCheckingCurrentUser.value = false;
            }
          },
        );
      } else {
        isCheckingCurrentUser.value = false;
      }
    } catch (e) {
      isCheckingCurrentUser.value = false;
      showToast(
          toastText: 'Something went wrong. Please login again',
          toastColor: ColorHelper.red);
      log('Error while checking current user: $e');
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
    isGoogleSigninLoaidng.value = true;
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
        nameController.value.text = user!.displayName!;
        UserModel? userModel = await getCurrentUser();
        isGoogleSigninLoaidng.value = false;
        if (userModel != null) {
          isGoogleSigninLoaidng.value = false;
          if (userModel.isDriverMode!) {
            await MethodHelper()
                .listerUserData(userId: FirebaseAuth.instance.currentUser!.uid)
                .listen(
              (userData) {
                currentUser.value = userData;
              },
            );
            Get.offAll(() => DriverHomeScreen(),
                transition: Transition.rightToLeft);
          } else {
            await MethodHelper()
                .listerUserData(userId: FirebaseAuth.instance.currentUser!.uid)
                .listen(
              (userData) {
                currentUser.value = userData;
              },
            );
            Get.offAll(() => const PassengerHomeScreen(),
                transition: Transition.rightToLeft);
          }
        } else {
          isGoogleSigninLoaidng.value = false;
          Get.to(() => const LocationPermissionScreen(),
              transition: Transition.rightToLeft);
        }
      } on FirebaseAuthException catch (e) {
        isGoogleSigninLoaidng.value = false;
        if (e.code == 'account-exists-with-different-credential') {
          showToast(
              toastText: 'Account exists with different credential',
              toastColor: ColorHelper.red);
        } else if (e.code == 'invalid-credential') {
          isGoogleSigninLoaidng.value = false;
          showToast(
              toastText: 'Invalid credential', toastColor: ColorHelper.red);
        }
      } catch (e) {
        isGoogleSigninLoaidng.value = false;
        showToast(
            toastText: 'Something went wrong. Please try again later',
            toastColor: ColorHelper.red);
        log('Error while sing in with google: $e');
      }
    } else {
      isGoogleSigninLoaidng.value = false;
    }
    return user;
  }

  Future<UserInfo?> signInWithPhoneNumber(String otp) async {
    isOtpSubmitLoading.value = true;
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
      UserModel? userModel = await getCurrentUser();
      if (userModel != null) {
        if (userModel.isDriverMode!) {
          await setUserType(type: userModel.isDriverMode!);

          await MethodHelper()
              .listerUserData(userId: FirebaseAuth.instance.currentUser!.uid)
              .listen(
            (userData) {
              currentUser.value = userData;
            },
          );
          isOtpSubmitLoading.value = false;
          Get.offAll(() => DriverHomeScreen(),
              transition: Transition.rightToLeft);
        } else {
          await setUserType(type: userModel.isDriverMode!);

          await MethodHelper()
              .listerUserData(userId: FirebaseAuth.instance.currentUser!.uid)
              .listen(
            (userData) {
              currentUser.value = userData;
            },
          );
          isOtpSubmitLoading.value = false;
          Get.offAll(() => const PassengerHomeScreen(),
              transition: Transition.rightToLeft);
        }
      } else {
        isOtpSubmitLoading.value = false;
        Get.to(() => const LocationPermissionScreen(),
            transition: Transition.rightToLeft);
      }
    } catch (e) {
      isOtpSubmitLoading.value = false;
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
      isUserDataSaving.value = true;
      UserModel? userModel;
      if (loginType == 'phone') {
        userModel = UserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          name: nameController.value.text,
          email: null,
          photo: null,
          lat: null,
          long: null,
          phone: '+${countryCode.value}${phoneNumbercontroller.value.text}',
          signInWith: 'phone',
          vehicleType: null,
          vehicleAngle: null,
          latLng: null,
          isDriverMode: isDriverMode.value,
          driverStatus: null,
          driverStatusDescription: null,
          driverVehicleType: null,
          isCityToCity: false,
          cityToCityStatus: null,
          cityToCityStatusDescription: null,
          cityToCityVehicleType: null,
          isCourier: false,
          courierStatus: null,
          courierStatusDescription: null,
          courierVehicleType: null,
          isFreight: false,
          freightStatus: null,
          freightStatusDescription: null,
          freightVehicleType: null,
        );
      } else {
        userModel = UserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          name: nameController.value.text,
          email: userInfo.email,
          photo: userInfo.photoURL,
          lat: null,
          long: null,
          phone: userInfo.phoneNumber,
          signInWith: 'google',
          vehicleType: null,
          vehicleAngle: null,
          latLng: null,
          isDriverMode: isDriverMode.value,
          driverStatus: null,
          driverStatusDescription: null,
          driverVehicleType: null,
          isCityToCity: false,
          cityToCityStatus: null,
          cityToCityStatusDescription: null,
          cityToCityVehicleType: null,
          isCourier: false,
          courierStatus: null,
          courierStatusDescription: null,
          courierVehicleType: null,
          isFreight: false,
          freightStatus: null,
          freightStatusDescription: null,
          freightVehicleType: null,
        );
      }
      var response = await AuthRepository().saveUserData(userModel: userModel);
      if (response) {
        await setLoginType(type: loginType);
        isUserDataSaving.value = false;
        Get.offAll(() => UserTypeSelectScreen(),
            transition: Transition.rightToLeft);
      } else {
        isUserDataSaving.value = false;
        showToast(
            toastText: 'Something went wrong. Please try again later',
            toastColor: ColorHelper.red);
      }
    } catch (e) {
      isUserDataSaving.value = false;
      showToast(
          toastText: 'Something went wrong. Please try again later',
          toastColor: ColorHelper.red);
    }
  }

  onPressPassenger() async {
    isDriverMode.value = false;
    await setUserType(type: false);
    await MethodHelper()
        .listerUserData(userId: FirebaseAuth.instance.currentUser!.uid)
        .listen(
      (userData) {
        currentUser.value = userData;
      },
    );
    Get.offAll(() => const PassengerHomeScreen(),
        transition: Transition.rightToLeft);
  }

  onPressDriver() async {
    isDriverMode.value = true;
    await setUserType(type: true);
    Get.offAll(() => VehicleTypeScreen(), transition: Transition.rightToLeft);
  }

  Future setUserType({required bool type}) async {
    await SharedPreferenceHelper()
        .setBool(key: SharedPreferenceKeys.isDriverMode, value: type);
  }

  Future setLoginType({required String type}) async {
    await SharedPreferenceHelper()
        .setString(key: SharedPreferenceKeys.loginType, value: type);
  }

  signOut() async {
    String? loginType = await SharedPreferenceHelper()
        .getStirng(key: SharedPreferenceKeys.loginType);
    if (loginType == 'phone') {
      phoneSignOut();
    } else {
      googleSignOut();
    }
  }

  googleSignOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => RegisterScreen(), transition: Transition.rightToLeft);
  }

  phoneSignOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => RegisterScreen(), transition: Transition.rightToLeft);
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var response = await AuthRepository().getUserById(userId: userId);
      if (response != null) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      showToast(toastText: 'Something went worng', toastColor: ColorHelper.red);
      log('Error while checking user: $e');
      return null;
    }
  }

  Future<DriverInfoModel?> getCurrentUserDriverData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var response =
          await AuthRepository().getCurrentUserDriverData(userId: userId);
      if (response != null) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      showToast(toastText: 'Something went worng', toastColor: ColorHelper.red);
      log('Error while checking user: $e');
      return null;
    }
  }
}
