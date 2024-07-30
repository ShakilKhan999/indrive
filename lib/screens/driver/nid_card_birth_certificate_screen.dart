import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';

class NidCardBirthCertificateScreen extends StatelessWidget {
  const NidCardBirthCertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          titleText: 'National Identity OR Birth Certificate', onTap: () {}),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SpaceHelper.verticalSpace20,
          _buildNidBirthCertificateCardInfoView(),
          SpaceHelper.verticalSpace20,
          _buildSubmitButton(),
          SpaceHelper.verticalSpace40,
        ],
      ),
    );
  }

  Widget _buildNidBirthCertificateCardInfoView() {
    return CommonComponents().addPhotoInfo(
      title: 'National Identity Card OR Birth Certificate',
      imgPath: 'assets/images/card_front.png',
      buttonText: 'Add a photo',
      onButtonPressed: () {},
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
