import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';

import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/city_to_city/controller/cityToCity_controller.dart';

import '../../../../main.dart';

class CityToCityDriverLicenceScreen extends StatelessWidget {
  CityToCityDriverLicenceScreen({super.key});
  final CityToCityInfoController _cityToCityInfoController =
      Get.put(CityToCityInfoController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: SimpleAppbar(titleText: 'Driver licence'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Obx(
          () => Column(
            children: [
              SpaceHelper.verticalSpace15,
              _buildDriverLicenseTextFiled(),
              SpaceHelper.verticalSpace15,
              _buildFrontAddPhotoView(),
              SpaceHelper.verticalSpace20,
              _buildBackAddPhotoView(),
              SpaceHelper.verticalSpace20,
              _buildSubmitButton(),
              SpaceHelper.verticalSpace40,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontAddPhotoView() {
    return CommonComponents().addPhotoInfo(
      title: "The front of driver's license",
      imgPath: _cityToCityInfoController.licenseFrontPhoto.value != ''
          ? _cityToCityInfoController.licenseFrontPhoto.value
          : 'assets/images/card_front.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _cityToCityInfoController.isLicenseFrontPhotoloading.value,
      onButtonPressed: () {
        _cityToCityInfoController.uploadLicenseFrontPhoto();
      },
      instructions: [
        "Smart card",
        "Temporary Driving License",
      ],
    );
  }

  Widget _buildBackAddPhotoView() {
    return CommonComponents().addPhotoInfo(
      title: "The back of driver's license",
      imgPath: _cityToCityInfoController.licenseBackPhoto.value != ''
          ? _cityToCityInfoController.licenseBackPhoto.value
          : 'assets/images/card_back.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _cityToCityInfoController.isLicenseBackPhotoloading.value,
      onButtonPressed: () {
        _cityToCityInfoController.uploadLicenseBackPhoto();
      },
      instructions: [
        "Smart card",
        "Temporary Driving License",
      ],
    );
  }

  Widget _buildDriverLicenseTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'Driver License',
          textController:
              _cityToCityInfoController.driverLicenseController.value),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          final driverLicenseNumber =
              _cityToCityInfoController.driverLicenseController.value.text;
          final licenseFrontPhoto =
              _cityToCityInfoController.licenseFrontPhoto.value;
          final licenseBackPhoto =
              _cityToCityInfoController.licenseBackPhoto.value;

          if (driverLicenseNumber.isEmpty) {
            showToast(
              toastText: "Please enter your driver license number.",
              toastColor: ColorHelper.red,
            );
          } else if (licenseFrontPhoto == '') {
            showToast(
              toastText:
                  "Please add a photo of the front of the driver’s license.",
              toastColor: ColorHelper.red,
            );
          } else if (licenseBackPhoto == '') {
            showToast(
              toastText:
                  "Please add a photo of the back of the driver’s license.",
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
}
