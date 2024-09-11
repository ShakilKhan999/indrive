import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      appBar: CustomAppbar(titleText: 'Profile settings', onTap: () {
        Get.back();
      }),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpaceHelper.verticalSpace20,
                    _buildProfilePictureView(),
                    _buildNameEditView(),
                    _buildEmailEditView(),
                    _buildLocationEditView(),
                    SpaceHelper.verticalSpace20,
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButtonView()
        ],
      ),
    );
  }

  Widget _buildProfilePictureView() {
    return Container(
      height: 100.h,
      width: 100.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: Colors.white,
          border: Border.all(color: Colors.white)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: _authController.currentUser.value.photo != null
            ? Image.network(
                _authController.currentUser.value.photo!,
                height: 100.h,
                width: 100.h,
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/images/person.jpg",
                height: 100.h,
                width: 100.h,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildNameEditView() {
    return commonTextField(
        controller: _authController.fullNameController.value,
        labelText: 'Full name',
        prefixIcon: const Icon(
          Icons.person_rounded,
          color: Colors.white30,
        ));
  }

  Widget _buildEmailEditView() {
    return commonTextField(
        controller: _authController.emailController.value,
        labelText: 'Email',
        enebled: false,
        prefixIcon: const Icon(
          Icons.email,
          color: Colors.white30,
        ));
  }

  Widget _buildLocationEditView() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_city,
            color: Colors.white30,
          ),
          SpaceHelper.horizontalSpace10,
          CommonComponents().printText(
              fontSize: 14,
              textData: _authController.selectedLocation.value,
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildBottomButtonView() {
    return Padding(
      padding:
          EdgeInsets.only(left: 16.0.sp, top: 10.h, right: 16.w, bottom: 20.h),
      child: CommonComponents().commonButton(text: 'Update', onPressed: () {}),
    );
  }

  Widget commonTextField({
    required TextEditingController controller,
    required String labelText,
    required Icon prefixIcon,
    bool enebled = true,
  }) {
    return Container(
      padding:
          EdgeInsets.only(left: 16.0.sp, top: 10.h, right: 16.w, bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: enebled,
            cursorColor: Colors.white10,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: prefixIcon,
              border: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
