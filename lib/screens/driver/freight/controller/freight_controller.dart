import 'package:get/get.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/method_helper.dart';
import 'package:indrive/utils/firebase_image_locations.dart';
import 'package:indrive/utils/global_toast_service.dart';
import 'package:intl/intl.dart';

class FreightController extends GetxController {
  var vehicleType = ''.obs;

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

  setVehicleType({required String vehicleType}) {
    if (vehicleType == 'car') {
      vehicleBrands = carBrands;
    }
    if (vehicleType == 'taxi') {
      vehicleBrands = taxiBrands;
    }
    if (vehicleType == 'bike') {
      vehicleBrands = bikeBrands;
    }
  }
}
