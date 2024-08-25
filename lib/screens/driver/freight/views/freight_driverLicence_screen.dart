import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/screens/driver/freight/controller/freight_controller.dart';

class FreightDriverlicenceScreen extends StatelessWidget {
  FreightDriverlicenceScreen({super.key});
  final FreightController _freightController = Get.put(FreightController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: CustomAppbar(titleText: 'Driver licence', onTap: () {}),
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
      imgPath: _freightController.licenseFrontPhoto.value != ''
          ? _freightController.licenseFrontPhoto.value
          : 'assets/images/card_front.png',
      buttonText: 'Add a photo',
      isLoading: _freightController.isLicenseFrontPhotoloading.value,
      onButtonPressed: () {
        _freightController.uploadLicenseFrontPhoto();
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
      imgPath: _freightController.licenseBackPhoto.value != ''
          ? _freightController.licenseBackPhoto.value
          : 'assets/images/card_back.png',
      buttonText: 'Add a photo',
      isLoading: _freightController.isLicenseBackPhotoloading.value,
      onButtonPressed: () {
        _freightController.uploadLicenseBackPhoto();
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
          textController: _freightController.driverLicenseController.value),
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
