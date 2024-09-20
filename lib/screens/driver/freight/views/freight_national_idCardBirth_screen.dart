import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';

import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/screens/driver/freight/controller/freight_controller.dart';

class FreightNationalIdcardbirthScreen extends StatelessWidget {
  FreightNationalIdcardbirthScreen({super.key});
  final FreightController _freightController = Get.put(FreightController());

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
      imgPath: _freightController.nationalIdCardPhoto.value != ''
          ? _freightController.nationalIdCardPhoto.value
          : 'assets/images/card_front.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _freightController.isNationalIdCardPhotoloading.value,
      onButtonPressed: () {
        _freightController.uploadNationalIdCardPhoto();
      },
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          if (_freightController.nationalIdCardPhoto.value == '') {
            showToast(
              toastText: "Please upload your National Identity.",
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
}
