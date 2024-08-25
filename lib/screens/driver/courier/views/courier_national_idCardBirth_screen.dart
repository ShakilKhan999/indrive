import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/screens/driver/courier/controller/controller.dart';

class CourierNationalIdcardbirthScreen extends StatelessWidget {
  CourierNationalIdcardbirthScreen({super.key});
  final CourierController _courierController = Get.put(CourierController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: CustomAppbar(
          titleText: 'National Identity OR Birth Certificate', onTap: () {}),
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
      imgPath: _courierController.nationalIdCardPhoto.value != ''
          ? _courierController.nationalIdCardPhoto.value
          : 'assets/images/card_front.png',
      buttonText: 'Add a photo',
      isLoading: _courierController.isNationalIdCardPhotoloading.value,
      onButtonPressed: () {
        _courierController.uploadNationalIdCardPhoto();
      },
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
