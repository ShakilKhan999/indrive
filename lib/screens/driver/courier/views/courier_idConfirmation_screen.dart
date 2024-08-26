import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/screens/driver/courier/controller/courier_controller.dart';

class CourierIdconfirmationScreen extends StatelessWidget {
  CourierIdconfirmationScreen({super.key});

  final CourierController _courierController = Get.put(CourierController());

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
      imgPath: _courierController.idCardWithFacePhoto.value != ''
          ? _courierController.idCardWithFacePhoto.value
          : 'assets/images/identity.png',
      buttonText: 'Add a photo',
      isLoading: _courierController.isIdCardWithFacePhotoloading.value,
      onButtonPressed: () {
        _courierController.uploadIdCardWithFacePhoto();
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
