import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/method_helper.dart';
import 'package:indrive/utils/firebase_image_locations.dart';
import 'package:indrive/utils/global_toast_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../main.dart';
import '../../../../models/driver_info_model.dart';
import '../../../../utils/database_collection_names.dart';
import '../repository/freight_repository.dart';

class FreightController extends GetxController {
  var vehicleType = ''.obs;
  var isFreightDataSaving = false.obs;

  // basic info----->>>>>
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var profilePhoto = ''.obs;
  var isProfilePhotoUploading = false.obs;
  var profilePhotoUrl = ''.obs;
  var selectedDate = ''.obs;

  // license------->>>>>>
  var driverLicenseController = TextEditingController().obs;
  var licenseFrontPhotoUrl = ''.obs;
  var licenseFrontPhoto = ''.obs;
  var isLicenseFrontPhotoloading = false.obs;
  var licensebackPhotoUrl = ''.obs;
  var licenseBackPhoto = ''.obs;
  var isLicenseBackPhotoloading = false.obs;

  // id card confirmation------>>>>
  var idCardWithFacefPhotoUrl = ''.obs;
  var idCardWithFacePhoto = ''.obs;
  var isIdCardWithFacePhotoloading = false.obs;

  // national id card----->>>>
  var nationalIdCardPhotoUrl = ''.obs;
  var nationalIdCardPhoto = ''.obs;
  var isNationalIdCardPhotoloading = false.obs;

  // vhicle info------>>>>>>
  var carModelNumberController = TextEditingController().obs;
  var selectedSeatNumber = ''.obs;
  var selectedCarColor = ''.obs;
  var selectedCarBrand = ''.obs;

  //freightScreen---------->>>>>>
  var pickUpController = TextEditingController().obs;
  var destinationController = TextEditingController().obs;
  var descriptionCargoController = TextEditingController().obs;
  var offerFareController = TextEditingController().obs;
  var selectedSize = 'Small'.obs;

  // List of dropdown items
  final List<String> sizes = ['Small', 'Medium', 'Big'];

  // Method to change the selected size
  void setSelectedSize(String? value) {
    if (value != null) {
      selectedSize.value = value;
    }
  }

  void uploadProfilePhoto() async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        profilePhoto.value = file.path;
        isProfilePhotoUploading.value = true;
        profilePhotoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: profileImage))!;
        isProfilePhotoUploading.value = false;
        log('Profile image url: ${profilePhotoUrl.value}');
      } else {
        showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
      }
    } catch (e) {
      profilePhoto.value = '';
      isProfilePhotoUploading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  void uploadLicenseFrontPhoto() async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        licenseFrontPhoto.value = file.path;
        isLicenseFrontPhotoloading.value = true;
        licenseFrontPhotoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: drivingLicenseImage))!;
        isLicenseFrontPhotoloading.value = false;
        log('driving front image url: ${profilePhotoUrl.value}');
      } else {
        showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
      }
    } catch (e) {
      licenseFrontPhoto.value = '';
      isLicenseFrontPhotoloading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  void uploadLicenseBackPhoto() async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        licenseBackPhoto.value = file.path;
        isLicenseBackPhotoloading.value = true;
        licensebackPhotoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: drivingLicenseImage))!;
        isLicenseBackPhotoloading.value = false;
        log('driving back image url: ${profilePhotoUrl.value}');
      } else {
        showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
      }
    } catch (e) {
      licenseBackPhoto.value = '';
      isLicenseBackPhotoloading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  void uploadIdCardWithFacePhoto() async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        idCardWithFacePhoto.value = file.path;
        isIdCardWithFacePhotoloading.value = true;
        idCardWithFacefPhotoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: idCardImage))!;
        isIdCardWithFacePhotoloading.value = false;
        log('id card with face image url: ${profilePhotoUrl.value}');
      } else {
        showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
      }
    } catch (e) {
      idCardWithFacePhoto.value = '';
      isIdCardWithFacePhotoloading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  void uploadNationalIdCardPhoto() async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        nationalIdCardPhoto.value = file.path;
        isNationalIdCardPhotoloading.value = true;
        nationalIdCardPhotoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: nationalIdImage))!;
        isNationalIdCardPhotoloading.value = false;
        log('national id card image url: ${profilePhotoUrl.value}');
      } else {
        showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
      }
    } catch (e) {
      nationalIdCardPhoto.value = '';
      isNationalIdCardPhotoloading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

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

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
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

  List<String> bikeBrands = [
    'Harley-Davidson',
    'Honda',
    'Yamaha',
    'Kawasaki',
    'Ducati',
    'BMW Motorrad',
    'Suzuki',
    'KTM',
    'Triumph',
    'Aprilia',
    'Indian Motorcycle',
    'Royal Enfield',
    'MV Agusta',
    'Moto Guzzi',
    'Husqvarna'
  ];
  List<String> taxiBrands = [
    'Maruti Suzuki',
    'Hyundai',
    'Tata Motors',
    'Mahindra',
    'Honda',
    'Toyota',
    'Ford',
    'Chevrolet',
    'Nissan',
    'Renault'
  ];

  List<String> vehicleBrands = [];

  final List<String> seatNumbers = ["Small", "Medium", "Large"].obs;
  final List<String> carColors = ["Red", "Blue", "Black", "White", "Grey"].obs;

  Future saveDriverInfo() async {
    try {
      fToast.init(Get.context!);
      isFreightDataSaving.value = true;
      var uuid = const Uuid();
      String id = uuid.v1();
      DriverInfoModel driverInfoModel = DriverInfoModel(
        id: id,
        uid: FirebaseAuth.instance.currentUser!.uid,
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
        vehicleType: 'freight',
      );
      log('driver info model : ${jsonEncode(driverInfoModel)}');
      var response = await FreightRepository().saveFreightInfo(
          driverInfoModel: driverInfoModel,
          uid: FirebaseAuth.instance.currentUser!.uid,
          driverInfoDoc: id);
      if (response) {
        await updateFreightStatus();
        isFreightDataSaving.value = false;
        Get.back();
      } else {
        isFreightDataSaving.value = false;
        showToast(
            toastText: 'Something went wrong. Please try again later',
            toastColor: ColorHelper.red);
      }
    } catch (e) {
      log('Error when calling save data: $e');
      isFreightDataSaving.value = false;
      showToast(
          toastText: 'Something went wrong. Please try again later',
          toastColor: ColorHelper.red);
    }
  }

  updateFreightStatus() async {
    try {
      await MethodHelper().updateDocFields(
          docId: FirebaseAuth.instance.currentUser!.uid,
          fieldsToUpdate: {
            "isFreight": true,
            "freightStatus": "pending",
            "freightVehicleType": 'freight',
          },
          collection: userCollection);
    } catch (e) {
      log('Error while updating freight data: $e');
    }
  }

  var photoPath = ''.obs;
  var isPhotoLoading = false.obs;
  var photoUrl = ''.obs;

  void addPhoto(String imageLocationName) async {
    try {
      File? file = await MethodHelper().pickImage();
      if (file != null) {
        photoPath.value = file.path;
        isPhotoLoading.value = true;
        photoUrl.value = (await MethodHelper()
            .uploadImage(file: file, imageLocationName: imageLocationName))!;
        isPhotoLoading.value = false;
        log('Photo URL: ${photoUrl.value}');
      } else {
        showToast(toastText: 'No image selected', toastColor: ColorHelper.red);
      }
    } catch (e) {
      photoPath.value = '';
      isPhotoLoading.value = false;
      showToast(toastText: 'Something went wrong', toastColor: ColorHelper.red);
    }
  }

  var selectedButtonIndex =
      (-1).obs; // -1 means no button is selected initially.

  void selectButton(int index) {
    selectedButtonIndex.value = index;
  }
}
