import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/city_to_city/controller/cityToCity_controller.dart';

import '../../../../main.dart';

class CityToCityVehicleInfoScreen extends StatelessWidget {
  CityToCityVehicleInfoScreen({super.key});
  final CityToCityInfoController _cityToCityInfoController =
      Get.put(CityToCityInfoController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: CustomAppbar(titleText: 'Vehicle info', onTap: () {}),
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
            _cityToCityInfoController.vehicleType.value == 'car' ||
                    _cityToCityInfoController.vehicleType.value == 'taxi'
                ? _buildSeatAndColorRow()
                : SizedBox(),
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
          Get.back();
        },
        text: 'Submit',
      ),
    );
  }

  Widget _buildCarBrandNameView() {
    return _buildDropdownSearch(
      textData:
          "${_cityToCityInfoController.vehicleType.value.toUpperCase()} Brand ",
      hintText: 'Select brand',
      items: _cityToCityInfoController.vehicleBrands,
      searchHintText: 'Select brand...',
      onChanged: (value) {
        _cityToCityInfoController.selectedCarBrand.value = value ?? '';
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
          textController:
              _cityToCityInfoController.carModelNumberController.value),
    );
  }

  Widget _buildSeatAndColorRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownSearch(
            textData: "Numbers of seat",
            hintText: 'Select seat number',
            items: _cityToCityInfoController.seatNumbers,
            searchHintText: 'Search seat numbers...',
            onChanged: (value) {
              _cityToCityInfoController.selectedSeatNumber.value = value ?? '';
            },
          ),
        ),
        Expanded(
          child: _buildDropdownSearch(
            textData: "Colors of the car",
            hintText: 'Select car color',
            items: _cityToCityInfoController.carColors,
            searchHintText: 'Search car colors...',
            onChanged: (value) {
              _cityToCityInfoController.selectedCarColor.value = value ?? '';
            },
          ),
        ),
      ],
    );
  }
}
