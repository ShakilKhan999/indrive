import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';

import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/city_to_city/controller/cityToCity_controller.dart';

import '../../../../main.dart';

class CityToCityNidCardBirthCertificateScreen extends StatelessWidget {
  CityToCityNidCardBirthCertificateScreen({super.key});

  final CityToCityInfoController _cityToCityInfoController =
      Get.put(CityToCityInfoController());

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
      imgPath: _cityToCityInfoController.nationalIdCardPhoto.value != ''
          ? _cityToCityInfoController.nationalIdCardPhoto.value
          : 'assets/images/card_front.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      isLoading: _cityToCityInfoController.isNationalIdCardPhotoloading.value,
      onButtonPressed: () {
        _cityToCityInfoController.uploadNationalIdCardPhoto();
      },
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          if (_cityToCityInfoController.nationalIdCardPhoto.value == '') {
            showToast(
              toastText: "Please upload your National Identity",
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
