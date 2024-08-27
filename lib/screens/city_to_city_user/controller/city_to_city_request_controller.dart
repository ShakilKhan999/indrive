import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityToCityRequestController extends GetxController {
  var fromController = TextEditingController().obs;
  var toController = TextEditingController().obs;
  var riderFareController = TextEditingController().obs;
  var parcelFareController = TextEditingController().obs;
  var parcelDescriptionController = TextEditingController().obs;
  var numberOfPassengers = Rx<int>(0);
  var selectedOptionIndex = 0.obs;
  var selectedDate = Rx<DateTime?>(null);

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }
}
