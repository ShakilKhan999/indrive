import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/method_helper.dart';
import 'package:indrive/models/driver_info_model.dart';
import 'package:indrive/screens/driver/driver_home/views/driver_home_screen.dart';
import 'package:indrive/screens/driver/driver_info/repository/driver_info_repository.dart';
import 'package:indrive/utils/global_toast_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/firebase_image_locations.dart';

class DriverInfoController extends GetxController {
  var vehicleType = ''.obs;

  // basic info----->>>>>
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var profilePhotoUrl = ''.obs;
  var selectedDate = ''.obs;

  // license------->>>>>>
  var driverLicenseController = TextEditingController().obs;
  var licenseFrontPhotoUrl = ''.obs;
  var licensebackPhotoUrl = ''.obs;

  // id card confirmation------>>>>
  var idCardWithFacefPhotoUrl = ''.obs;

  // national id card----->>>>
  var nationalIdCardPhotoUrl = ''.obs;

  // vhicle info------>>>>>>
  var carModelNumberController = TextEditingController().obs;
  var selectedSeatNumber = ''.obs;
  var selectedCarColor = ''.obs;
  var selectedCarBrand = ''.obs;

  saveDriverInfo() async {
    try {
      var uuid = const Uuid();
      String id = uuid.v1();
      DriverInfoModel driverInfoModel = DriverInfoModel(
        id: id,
        firstName: firstNameController.value.text,
        lastName: lastNameController.value.text,
        email: emailController.value.text,
        profilePhoto: profilePhotoUrl.value,
        dateOfBirth: selectedDate.value,
        driverLicense: driverLicenseController.value.text,
        driverLicenseFrontPhoto: licenseFrontPhotoUrl.value,
        driverLicenseBackPhoto: licensebackPhotoUrl.value,
        idWithPhoto: idCardWithFacefPhotoUrl.value,
        nid: nationalIdCardPhotoUrl.value,
        vehicleBrand: selectedCarBrand.value,
        vehicleNumberOfSeat: selectedSeatNumber.value,
        vehicleColor: selectedCarColor.value,
        vehicleModelNo: carModelNumberController.value.text,
        vehicleType: vehicleType.value,
      );
      log('driver info model : ${jsonEncode(driverInfoModel)}');
      var response = await DriverInfoRepository().saveDriverInfoData(
          driverInfoModel: driverInfoModel,
          uid: FirebaseAuth.instance.currentUser!.uid,
          driverInfoDoc: id);
      if (response) {
        showToast(
            toastText: 'Data saved successfully',
            toastColor: ColorHelper.primaryColor);
        Get.offAll(() => DriverHomeScreen());
      } else {
        showToast(
            toastText: 'Something went wrong. Please try again later',
            toastColor: ColorHelper.red);
      }
    } catch (e) {
      log('Error when calling save data: $e');
      showToast(
          toastText: 'Something went wrong. Please try again later',
          toastColor: ColorHelper.red);
    }
  }

  final List<String> carBrands = [
    'Toyota',
    'Honda',
    'Ford',
    'Chevrolet',
    'Nissan',
    'BMW',
    'Mercedes-Benz',
    'Volkswagen',
    'Audi',
    'Hyundai',
  ].obs;

  final List<String> seatNumbers = ["2", "4", "5", "7", "8"].obs;
  final List<String> carColors = ["Red", "Blue", "Black", "White", "Grey"].obs;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setSelectedDate(picked);
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = dateFormat.format(date);
  }

  void uploadProfilePhoto() async {
    File? file = await MethodHelper().pickImage();
    if (file != null) {
      profilePhotoUrl.value = (await MethodHelper()
          .uploadImage(file: file, imageLocationName: profileImage))!;
      showToast(
          toastText: 'Image uploaded', toastColor: ColorHelper.primaryColor);
      log('Profile image url: ${profilePhotoUrl.value}');
    } else {
      showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
    }
  }

  void uploadLicenseFrontPhoto() async {
    File? file = await MethodHelper().pickImage();
    if (file != null) {
      licenseFrontPhotoUrl.value = (await MethodHelper()
          .uploadImage(file: file, imageLocationName: drivingLicenseImage))!;
      showToast(
          toastText: 'Image uploaded', toastColor: ColorHelper.primaryColor);
      log('driving front image url: ${profilePhotoUrl.value}');
    } else {
      showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
    }
  }

  void uploadLicenseBackPhoto() async {
    File? file = await MethodHelper().pickImage();
    if (file != null) {
      licensebackPhotoUrl.value = (await MethodHelper()
          .uploadImage(file: file, imageLocationName: drivingLicenseImage))!;
      showToast(
          toastText: 'Image uploaded', toastColor: ColorHelper.primaryColor);
      log('driving back image url: ${profilePhotoUrl.value}');
    } else {
      showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
    }
  }

  void uploadIdCardWithFacePhoto() async {
    File? file = await MethodHelper().pickImage();
    if (file != null) {
      idCardWithFacefPhotoUrl.value = (await MethodHelper()
          .uploadImage(file: file, imageLocationName: idCardImage))!;
      showToast(
          toastText: 'Image uploaded', toastColor: ColorHelper.primaryColor);
      log('id card with face image url: ${profilePhotoUrl.value}');
    } else {
      showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
    }
  }

  void uploadNationalIdCardPhoto() async {
    File? file = await MethodHelper().pickImage();
    if (file != null) {
      nationalIdCardPhotoUrl.value = (await MethodHelper()
          .uploadImage(file: file, imageLocationName: nationalIdImage))!;
      showToast(
          toastText: 'Image uploaded', toastColor: ColorHelper.primaryColor);
      log('national id card image url: ${profilePhotoUrl.value}');
    } else {
      showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
    }
  }
}
