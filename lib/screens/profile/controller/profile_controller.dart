import 'dart:developer';
import 'dart:io';

import 'package:callandgo/helpers/method_helper.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/models/driver_vehicle_status.dart';
import 'package:callandgo/models/user_model.dart';
import 'package:callandgo/screens/profile/repository/profile_repository.dart';

import '../../../utils/database_collection_names.dart';
import '../../../utils/firebase_image_locations.dart';

class ProfileController extends GetxController {
  // @override
  // void onInit() {
  //   getUserProfile();
  //   super.onInit();
  // }

  var userData = UserModel().obs;
  var cityRiderStatus = DriverVehicleStatus().obs;
  var courierStatus = DriverVehicleStatus().obs;
  var freightStatus = DriverVehicleStatus().obs;
  var cityToCityStatus = DriverVehicleStatus().obs;
  var isUserDataLoaded = false.obs;

  Future<void> getUserProfile() async {
    try {
      isUserDataLoaded.value = false;
      final documentSnapshot = await ProfileRepository()
          .getUserProfileData(userId: FirebaseAuth.instance.currentUser!.uid);
      if (documentSnapshot != null && documentSnapshot.exists) {
        userData.value =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        getDriverStatus(type: 'cityRider');
        getDriverStatus(type: 'courier');
        getDriverStatus(type: 'freight');
        getDriverStatus(type: 'cityToCity');
        isUserDataLoaded.value = true;
      } else {
        print('User document does not exist');
        isUserDataLoaded.value = true;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      isUserDataLoaded.value = true;
    }
  }

  getDriverStatus({required String type}) {
    if (type == 'cityRider') {
      if (userData.value.isDriver == true) {
        if (userData.value.driverStatus!.toLowerCase() == 'pending') {
          cityRiderStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.driverStatus!.toLowerCase() == 'approved') {
          cityRiderStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.driverStatus!.toLowerCase() == 'rejected') {
          cityRiderStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        cityRiderStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    } else if (type == 'courier') {
      if (userData.value.isCourier == true) {
        if (userData.value.courierStatus!.toLowerCase() == 'pending') {
          courierStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.courierStatus!.toLowerCase() == 'approved') {
          courierStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.courierStatus!.toLowerCase() == 'rejected') {
          courierStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        courierStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    } else if (type == 'freight') {
      if (userData.value.isFreight == true) {
        if (userData.value.freightStatus!.toLowerCase() == 'pending') {
          freightStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.freightStatus!.toLowerCase() == 'approved') {
          freightStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.freightStatus!.toLowerCase() == 'rejected') {
          freightStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        freightStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    } else if (type == 'cityToCity') {
      if (userData.value.isCityToCity == true) {
        if (userData.value.cityToCityStatus!.toLowerCase() == 'pending') {
          cityToCityStatus.value = DriverVehicleStatus(
              status: 'Verification pending', color: ColorHelper.blueColor);
        }
        if (userData.value.cityToCityStatus!.toLowerCase() == 'approved') {
          cityToCityStatus.value = DriverVehicleStatus(
              status: 'Registration completed', color: ColorHelper.blueColor);
        }
        if (userData.value.cityToCityStatus!.toLowerCase() == 'rejected') {
          cityToCityStatus.value = DriverVehicleStatus(
              status: 'Verification failed', color: ColorHelper.red);
        }
      } else {
        cityToCityStatus.value = DriverVehicleStatus(
            status: 'Not Registered', color: ColorHelper.greyColor);
      }
    }
  }

  bool hasUserData() {
    return userData.value.uid != null &&
        userData.value.uid!.isNotEmpty &&
        userData.value.name != null &&
        userData.value.name!.isNotEmpty;
  }

  var isProfileUpdateLoading = false.obs;
  updateProfileInfo() async {
    AuthController authController = Get.find();
    fToast.init(Get.context!);
    if (authController.fullNameController.value.text.isEmpty) {
      showToast(toastText: 'Please enter your name');
      return;
    }

    try {
      isProfileUpdateLoading.value = true;
      Map<String, dynamic> fieldsToUpdate = {
        'name': authController.fullNameController.value.text,
      };
      FocusScope.of(Get.context!).unfocus();
      bool result = await MethodHelper().updateDocFields(
          docId: userData.value.uid!,
          fieldsToUpdate: fieldsToUpdate,
          collection: userCollection);
      if (result) {
        isProfileUpdateLoading.value = false;
        showToast(
            toastText: 'Profile updated', toastColor: ColorHelper.primaryColor);
      } else {
        isProfileUpdateLoading.value = false;
        showToast(
            toastText: 'Profile update failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      isProfileUpdateLoading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
      log("Error while updating profile: $e");
    }
  }

  var profilePhoto = ''.obs;
  var isProfilePhotoUploading = false.obs;
  var profilePhotoUrl = ''.obs;
  void uploadProfilePhoto() async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        profilePhoto.value = file.path;
        isProfilePhotoUploading.value = true;
        profilePhotoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: profileImage))!;

        log('Profile image url: ${profilePhotoUrl.value}');
        updateProfilePhoto();
      } else {
        isProfilePhotoUploading.value = false;
        showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
      }
    } catch (e) {
      profilePhoto.value = '';
      isProfilePhotoUploading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  updateProfilePhoto() async {
    try {
      fToast.init(Get.context!);
      Map<String, dynamic> fieldsToUpdate = {
        'photo': profilePhotoUrl.value,
      };
      bool result = await MethodHelper().updateDocFields(
          docId: userData.value.uid!,
          fieldsToUpdate: fieldsToUpdate,
          collection: userCollection);
      if (result) {
        isProfilePhotoUploading.value = false;
        showToast(
            toastText: 'Profile updated', toastColor: ColorHelper.primaryColor);
      } else {
        isProfilePhotoUploading.value = false;
        showToast(
            toastText: 'Profile update failed', toastColor: ColorHelper.red);
      }
    } catch (e) {
      isProfilePhotoUploading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
      log("Error while updating profile: $e");
    }
  }
}
