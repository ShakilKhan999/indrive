import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';

import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/freight/controller/freight_controller.dart';

import '../../../../main.dart';

class FreightVehicleinfoScreen extends StatelessWidget {
  FreightVehicleinfoScreen({super.key});
  final FreightController _freightController = Get.put(FreightController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: SimpleAppbar(
        titleText: 'Vehicle info',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            SpaceHelper.verticalSpace20,
            _buildCarBrandNameView(),
            SpaceHelper.verticalSpace15,
            _buildModelNumberTextFiled(),
            SpaceHelper.verticalSpace15,
            _buildSeatAndColorRow(),
            SpaceHelper.verticalSpace15,
            _buildSubmitButton(),
            SpaceHelper.verticalSpace40,
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          if (_freightController.selectedCarBrand.value.isEmpty) {
            showToast(
              toastText: "Please select a truck brand.",
              toastColor: Colors.red,
            );
          } else if (_freightController
              .carModelNumberController.value.text.isEmpty) {
            showToast(
              toastText: "Please enter the car model number.",
              toastColor: Colors.red,
            );
          } else if (_freightController.selectedSeatNumber.value.isEmpty) {
            showToast(
              toastText: "Please select the seat number.",
              toastColor: Colors.red,
            );
          } else if (_freightController.selectedCarColor.value.isEmpty) {
            showToast(
              toastText: "Please select the car color.",
              toastColor: Colors.red,
            );
          } else {
            Get.back();
          }
        },
        text: 'Submit',
      ),
    );
  }

  Widget _buildCarBrandNameView() {
    return _buildDropdownSearch(
      textData: "${_freightController.vehicleType.toUpperCase()} Brand ",
      hintText: 'Select brand',
      items: _freightController.vehicleBrands,
      searchHintText: 'Select brand...',
      onChanged: (value) {
        _freightController.selectedCarBrand.value = value ?? '';
      },
    );
  }

  Widget _buildDropdownSearch({
    required String textData,
    required String hintText,
    required List<String> items,
    required String searchHintText,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpaceHelper.verticalSpace5,
          CommonComponents().printText(
              fontSize: 16,
              textData: textData,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          Container(
            margin: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.black)),
            child: DropdownFlutter<String>.search(
              closedHeaderPadding: EdgeInsets.all(20.sp),
              hintText: hintText,
              items: items,
              excludeSelected: false,
              searchHintText: searchHintText,
              listItemBuilder: (context, item, isSelected, onTap) {
                return ListTile(
                  title: Text(item),
                  selected: isSelected,
                  onTap: onTap,
                );
              },
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelNumberTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'Model Number',
          textController: _freightController.carModelNumberController.value),
    );
  }

  Widget _buildSeatAndColorRow() {
    return Column(
      children: [
        _buildDropdownSearch(
          textData: "Size of the Track",
          hintText: 'Select seat number',
          items: _freightController.seatNumbers,
          searchHintText: 'Search seat numbers...',
          onChanged: (value) {
            _freightController.selectedSeatNumber.value = value ?? '';
          },
        ),
        SpaceHelper.verticalSpace10,
        _buildDropdownSearch(
          textData: "Colors of the car",
          hintText: 'Select car color',
          items: _freightController.carColors,
          searchHintText: 'Search car colors...',
          onChanged: (value) {
            _freightController.selectedCarColor.value = value ?? '';
          },
        ),
      ],
    );
  }
}
