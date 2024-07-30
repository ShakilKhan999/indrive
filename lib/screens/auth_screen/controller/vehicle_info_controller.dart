import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/method_helper.dart';
import 'package:indrive/utils/global_toast_service.dart';
import 'package:intl/intl.dart';

import '../../../utils/firebase_image_locations.dart';

class VehicleInfoController extends GetxController {
  var emailController = TextEditingController().obs;
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var vehicleType = ''.obs;
  var profilePhotoUrl = ''.obs;
  var selectedDate = ''.obs;
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
    } else {
      showToast(toastText: 'Empty Image', toastColor: ColorHelper.red);
    }
  }
}
