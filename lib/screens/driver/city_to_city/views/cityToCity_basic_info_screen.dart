import 'package:callandgo/components/simple_appbar.dart';
import 'package:callandgo/utils/global_toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';

import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/main.dart';
import 'package:callandgo/screens/driver/city_to_city/controller/cityToCity_controller.dart';

class CityToCityBasicInfoScreen extends StatelessWidget {
  CityToCityBasicInfoScreen({super.key});
  final CityToCityInfoController _cityToCityInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppbar(titleText: 'Basic info'),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Obx(
          () => Column(
            children: [
              SpaceHelper.verticalSpace15,
              _buildAddPhotoView(),
              SpaceHelper.verticalSpace15,
              _buildFirstNameTextFiled(),
              SpaceHelper.verticalSpace15,
              _buildLastNameTextFiled(),
              SpaceHelper.verticalSpace15,
              _buildEmailTextFiled(),
              SpaceHelper.verticalSpace15,
              _buildDobView(context),
              SpaceHelper.verticalSpace15,
              _buildSubmitButton(),
              SpaceHelper.verticalSpace30,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'First name',
          textController: _cityToCityInfoController.firstNameController.value),
    );
  }

  Widget _buildLastNameTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'Last name',
          textController: _cityToCityInfoController.lastNameController.value),
    );
  }

  Widget _buildEmailTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'Email',
          textController: _cityToCityInfoController.emailController.value),
    );
  }

  Widget _buildAddPhotoView() {
    return CommonComponents().addPhotoInfo(
      title: 'Photo',
      imgPath: _cityToCityInfoController.profilePhoto.value != ''
          ? _cityToCityInfoController.profilePhoto.value
          : 'assets/images/addPhotoLogo.png',
      // color: ColorHelper.primaryColor,
      buttonText: 'Add a photo',
      onButtonPressed: () async {
        _cityToCityInfoController.uploadProfilePhoto();
      },
      isLoading: _cityToCityInfoController.isProfilePhotoUploading.value,
      instructions: [
        'Clearly face visible',
        'Without sunglasses',
        'Good lighting and without filters',
      ],
    );
  }

  Widget _buildDobView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of birth',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SpaceHelper.verticalSpace5,
            _buildDatePickerView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerView(BuildContext context) {
    return GestureDetector(
      onTap: () => _cityToCityInfoController.selectDate(context),
      child: Obx(
        () => Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            _cityToCityInfoController.selectedDate.value.isEmpty
                ? 'Select Date'
                : _cityToCityInfoController.selectedDate.value,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonButton(
        onPressed: () {
          final firstName =
              _cityToCityInfoController.firstNameController.value.text;
          final lastName =
              _cityToCityInfoController.lastNameController.value.text;
          final email = _cityToCityInfoController.emailController.value.text;
          final selectedDate = _cityToCityInfoController.selectedDate.value;
          final profilePhoto = _cityToCityInfoController.profilePhoto.value;

          if (profilePhoto == '') {
            showToast(
              toastText: "Please add a profile photo.",
              toastColor: ColorHelper.red,
            );
          } else if (firstName.isEmpty) {
            showToast(
              toastText: "Please enter your first name.",
              toastColor: ColorHelper.red,
            );
          } else if (lastName.isEmpty) {
            showToast(
              toastText: "Please enter your last name.",
              toastColor: ColorHelper.red,
            );
          } else if (email.isEmpty) {
            showToast(
              toastText: "Please enter your email.",
              toastColor: ColorHelper.red,
            );
          } else if (!_validateEmail(
              _cityToCityInfoController.emailController.value.text)) {
            showToast(
              toastText: "Invalid email format",
              toastColor: ColorHelper.red,
            );
          } else if (selectedDate.isEmpty) {
            showToast(
              toastText: "Please select your date of birth.",
              toastColor: ColorHelper.red,
            );
          } else {
            Get.back();
          }
        },
        text: 'Submit',
      ),
    );
  }

  bool _validateEmail(String email) {
    // Simple email validation regex
    String emailPattern =
        r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }
}
