import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/driver_info/controller/driver_info_controller.dart';

import '../../../../main.dart';

class NidCardBirthCertificateScreen extends StatelessWidget {
  NidCardBirthCertificateScreen({super.key});

  final DriverInfoController _driverInfoController =
      Get.put(DriverInfoController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: SimpleAppbar(titleText: 'National Identity OR Birth Certificate'),
      backgroundColor: Colors.white,
      body: Obx(
        () => Column(
          children: [
            SpaceHelper.verticalSpace20,
            _buildNidBirthCertificateCardInfoView(),
            SpaceHelper.verticalSpace20,
            _buildSubmitButton(),
            SpaceHelper.verticalSpace40,
          ],
        ),
      ),
    );
  }

  Widget _buildNidBirthCertificateCardInfoView() {
    return CommonComponents().addPhotoInfo(
      title: 'National Identity Card OR Birth Certificate',
      imgPath: _driverInfoController.nationalIdCardPhoto.value != ''
          ? _driverInfoController.nationalIdCardPhoto.value
          : 'assets/images/card_front.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _driverInfoController.isNationalIdCardPhotoloading.value,
      onButtonPressed: () {
        _driverInfoController.uploadNationalIdCardPhoto();
      },
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          fToast.init(Get.context!);
          if (_driverInfoController.nationalIdCardPhoto.value.isEmpty) {
            showToast(
              toastText: "National ID or Birth Certificate photo is required",
              toastColor: ColorHelper.red,
            );
          } else {
            Get.back(); // Proceed with submission or navigation
          }
        },
        text: 'Submit',
      ),
    );
  }
}
