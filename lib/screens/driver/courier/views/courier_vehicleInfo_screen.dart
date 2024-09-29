import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/screens/driver/courier/controller/courier_controller.dart';

import '../../../../models/vehicle_model.dart';

class CourierVehicleinfoScreen extends StatelessWidget {
  CourierVehicleinfoScreen({super.key});
  final CourierController _courierController = Get.put(CourierController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: SimpleAppbar(titleText: 'Vehicle info'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            SpaceHelper.verticalSpace20,
            _buildVehicleBrandNameView(),
            SpaceHelper.verticalSpace15,
            _buildVehicleModelView(),
            SpaceHelper.verticalSpace15,
            _courierController.vehicleType.value == 'car' ||
                    _courierController.vehicleType.value == 'taxi'
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
          final carBrand = _courierController.selectedVehicleBrand.value;
          final modelNumber = _courierController.selectedVehicleModel.value;
          final seatNumber = _courierController.selectedSeatNumber.value;
          final carColor = _courierController.selectedCarColor.value;

          if (carBrand.isEmpty) {
            showToast(
              toastText: "Please select a brand.",
              toastColor: ColorHelper.red,
            );
          } else if (modelNumber.isEmpty) {
            showToast(
              toastText: "Please enter the model number.",
              toastColor: ColorHelper.red,
            );
          } else if ((_courierController.vehicleType.value == 'car' ||
                  _courierController.vehicleType.value == 'taxi') &&
              (seatNumber.isEmpty || carColor.isEmpty)) {
            showToast(
              toastText: "Please select seat number and car color.",
              toastColor: ColorHelper.red,
            );
          } else {
            Get.back();
          }
        },
        text: 'Submit',
      ),
    );
  }

  Widget _buildVehicleBrandNameView() {
    return _buildBrandView(
      textData: "${_courierController.vehicleType.value.toUpperCase()} Brand ",
      hintText: 'Select brand',
      items: _courierController.vehicleBrands,
      searchHintText: 'Select brand...',
      onChanged: (value) {
        _courierController.selectedVehicleBrand.value = value!.brandName!;
        _courierController.vehicleModels.value = value.modelList!;
        _courierController.selectedVehicleModel.value = '';
      },
    );
  }

  Widget _buildBrandView({
    required String textData,
    required String hintText,
    required List<VehicleModel> items,
    required String searchHintText,
    required Function(VehicleModel?) onChanged,
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
            child: DropdownFlutter<VehicleModel>.search(
              closedHeaderPadding: EdgeInsets.all(20.sp),
              hintText: hintText,
              items: items,
              excludeSelected: false,
              searchHintText: searchHintText,
              listItemBuilder: (context, item, isSelected, onTap) {
                return ListTile(
                  title: Text(item.brandName!),
                  selected: isSelected,
                  onTap: onTap,
                );
              },
              headerBuilder: (context, selectedItem, enabled) {
                return Text(
                  selectedItem.brandName!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                );
              },
              onChanged: onChanged,
            ),
          ),
        ],
      ),
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

  // Widget _buildModelNumberTextFiled() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //     child: CommonComponents().commonTextPicker(
  //         labelText: 'Model Number',
  //         textController: _courierController.carModelNumberController.value),
  //   );
  // }

  Widget _buildVehicleModelView() {
    return _buildDropdownSearch(
      textData: "Model Number",
      hintText: 'Select Model Number',
      items: _courierController.vehicleModels.cast<String>(),
      searchHintText: 'Select model number...',
      onChanged: (value) {
        _courierController.selectedVehicleModel.value = value!;
      },
    );
  }

  Widget _buildSeatAndColorRow() {
    return Column(
      children: [
        _buildDropdownSearch(
          textData: "Numbers of seat",
          hintText: 'Select seat number',
          items: _courierController.seatNumbers,
          searchHintText: 'Search seat numbers...',
          onChanged: (value) {
            _courierController.selectedSeatNumber.value = value ?? '';
          },
        ),
        SpaceHelper.verticalSpace10,
        _buildDropdownSearch(
          textData: "Colors of the car",
          hintText: 'Select car color',
          items: _courierController.carColors,
          searchHintText: 'Search car colors...',
          onChanged: (value) {
            _courierController.selectedCarColor.value = value ?? '';
          },
        ),
      ],
    );
  }
}
