import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/screens/auth_screen/controller/auth_controller.dart';

class DriverLicenceScreen extends StatelessWidget {
  DriverLicenceScreen({super.key});
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleText: 'Driver licence', onTap: () {}),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
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
    );
  }

  Widget _buildFrontAddPhotoView() {
    return CommonComponents().addPhotoInfo(
      title: "The front of driver's license",
      imgPath: 'assets/images/card_front.png',
      buttonText: 'Add a photo',
      onButtonPressed: () {},
      instructions: [
        "Smart card",
        "Temporary Driving License",
      ],
    );
  }

  Widget _buildBackAddPhotoView() {
    return CommonComponents().addPhotoInfo(
      title: "The back of driver's license",
      imgPath: 'assets/images/card_back.png',
      buttonText: 'Add a photo',
      onButtonPressed: () {},
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
          textController: _authController.driverLicenseController.value),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {},
        text: 'Submit',
      ),
    );
  }
}
