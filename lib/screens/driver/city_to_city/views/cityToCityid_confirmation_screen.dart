import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/driver/city_to_city/controller/cityToCity_controller.dart';

import '../../../../main.dart';

class CityToCityIdConfirmationScreen extends StatelessWidget {
  CityToCityIdConfirmationScreen({super.key});

  final CityToCityInfoController _cityToCityInfoController =
      Get.put(CityToCityInfoController());

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      appBar: CustomAppbar(titleText: 'ID confirmation', onTap: () {}),
      backgroundColor: Colors.white,
      body: Obx(
        () => Column(
          children: [
            SpaceHelper.verticalSpace20,
            _buildIdentityCardView(),
            SpaceHelper.verticalSpace20,
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

  Widget _buildIdentityCardView() {
    return CommonComponents().addPhotoInfo(
      title: "Id Confirmation",
      imgPath: _cityToCityInfoController.idCardWithFacePhoto.value != ''
          ? _cityToCityInfoController.idCardWithFacePhoto.value
          : 'assets/images/identity.png',
      buttonText: 'Add a photo',
      isLoading: _cityToCityInfoController.isIdCardWithFacePhotoloading.value,
      onButtonPressed: () {
        _cityToCityInfoController.uploadIdCardWithFacePhoto();
      },
      instructions: [
        "Bring the driver's license in front of you and take a photo as an example",
        "The photo should clearly show the face and your driver's license",
        "The photo must be taken in good light and in good quality",
        "Photos in sunglasses are not allowed",
      ],
    );
  }
}
