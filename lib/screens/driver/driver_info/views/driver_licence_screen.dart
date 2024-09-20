import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/driver_info/controller/driver_info_controller.dart';

import '../../../../main.dart';

class DriverLicenceScreen extends StatelessWidget {
  DriverLicenceScreen({super.key});
  final DriverInfoController _driverInfoController =
      Get.put(DriverInfoController());

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
      imgPath: _driverInfoController.licenseFrontPhoto.value != ''
          ? _driverInfoController.licenseFrontPhoto.value
          : 'assets/images/card_front.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _driverInfoController.isLicenseFrontPhotoloading.value,
      onButtonPressed: () {
        _driverInfoController.uploadLicenseFrontPhoto();
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
      imgPath: _driverInfoController.licenseBackPhoto.value != ''
          ? _driverInfoController.licenseBackPhoto.value
          : 'assets/images/card_back.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _driverInfoController.isLicenseBackPhotoloading.value,
      onButtonPressed: () {
        _driverInfoController.uploadLicenseBackPhoto();
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
          textController: _driverInfoController.driverLicenseController.value),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          fToast.init(Get.context!);
          if (_driverInfoController
              .driverLicenseController.value.text.isEmpty) {
            showToast(
              toastText: 'Driver License is required',
              toastColor: ColorHelper.red,
            );
          } else if (_driverInfoController.licenseFrontPhoto.value.isEmpty) {
            showToast(
              toastText: "Driver's license front photo is required",
              toastColor: ColorHelper.red,
            );
          } else if (_driverInfoController.licenseBackPhoto.value.isEmpty) {
            showToast(
              toastText: "Driver's license back photo is required",
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
