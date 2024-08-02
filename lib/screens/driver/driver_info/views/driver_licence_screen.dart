import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/driver/driver_info/controller/driver_info_controller.dart';

import '../../../../main.dart';

class DriverLicenceScreen extends StatelessWidget {
  DriverLicenceScreen({super.key});
  final DriverInfoController _driverInfoController =
      Get.put(DriverInfoController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: CustomAppbar(titleText: 'Driver licence', onTap: () {}),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Obx(() => 
         Column(
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
          Get.back();
        },
        text: 'Submit',
      ),
    );
  }
}
