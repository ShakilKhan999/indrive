import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:indrive/components/common_components.dart';
import 'package:indrive/components/custom_appbar.dart';
import 'package:indrive/helpers/space_helper.dart';
import 'package:indrive/main.dart';
import 'package:indrive/screens/driver/courier/controller/courier_controller.dart';

class CourierBasicinfoScreen extends StatelessWidget {
  CourierBasicinfoScreen({super.key});
  final CourierController _courierController = Get.find();
  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(titleText: 'Basic info', onTap: () {}),
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
          textController: _courierController.firstNameController.value),
    );
  }

  Widget _buildLastNameTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'Last name',
          textController: _courierController.lastNameController.value),
    );
  }

  Widget _buildEmailTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CommonComponents().commonTextPicker(
          labelText: 'Email',
          textController: _courierController.emailController.value),
    );
  }

  Widget _buildAddPhotoView() {
    return CommonComponents().addPhotoInfo(
      title: 'Photo',
      imgPath: _courierController.profilePhoto.value != ''
          ? _courierController.profilePhoto.value
          : 'assets/images/addPhotoLogo.png',
      buttonText: 'Add a photo',
      onButtonPressed: () async {
        _courierController.uploadProfilePhoto();
      },
      isLoading: _courierController.isProfilePhotoUploading.value,
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
      onTap: () => _courierController.selectDate(context),
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
            _courierController.selectedDate.value.isEmpty
                ? 'Select Date'
                : _courierController.selectedDate.value,
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
          Get.back();
        },
        text: 'Submit',
      ),
    );
  }
}
