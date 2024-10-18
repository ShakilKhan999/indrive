import 'dart:developer';

import 'package:callandgo/screens/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/components/custom_appbar.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../helpers/style_helper.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthController _authController = Get.find();
  final ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        appBar: CustomAppbar(
            titleText: 'Profile settings',
            onTap: () {
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
                      InkWell(
                        onTap: () {
                          _showPhoneBottomSheet();
                        },
                        child: _buildPhoneEditView(),
                      ),
                      InkWell(
                        onTap: () {
                          _showLocationSelectionSheet();
                        },
                        child: _buildLocationEditView(),
                      ),
                      SpaceHelper.verticalSpace20,
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtonView()
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureView() {
    return InkWell(
      onTap: () {
        _profileController.uploadProfilePhoto();
      },
      child: Container(
        height: 100.h,
        width: 100.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: Colors.white,
            border: Border.all(color: Colors.white)),
        child: _profileController.isProfilePhotoUploading.value
            ? Center(
                child: CircularProgressIndicator(
                color: ColorHelper.primaryColor,
                strokeWidth: 2,
              ))
            : ClipRRect(
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

  Widget _buildPhoneEditView() {
    return Obx(
      () => Container(
        padding: EdgeInsets.only(left: 20.w, top: 20.h),
        child: Row(
          children: [
            Icon(
              Icons.phone,
              color: Colors.white30,
            ),
            SpaceHelper.horizontalSpace10,
            CommonComponents().printText(
                fontSize: 14,
                textData: _authController.profilePhone.value,
                fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneTextFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter mobile no.*',
          style: StyleHelper.regular14,
        ),
        SpaceHelper.verticalSpace10,
        SizedBox(
            height: 80.h,
            width: MediaQuery.of(Get.context!).size.width,
            child: IntlPhoneField(
              controller: _authController.phoneNumbercontroller.value,
              cursorColor: Colors.grey,
              style: StyleHelper.regular14,
              dropdownTextStyle: const TextStyle(color: Colors.grey),
              dropdownIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorHelper.primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
              initialCountryCode: 'BD',
              onCountryChanged: (value) {
                log(value.dialCode);
                _authController.countryCode.value = value.dialCode;
              },
              onChanged: (phone) {},
            )),
      ],
    );
  }

  Widget _buildLocationEditView() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_city,
              color: Colors.white30,
            ),
            SpaceHelper.horizontalSpace10,
            CommonComponents().printText(
                fontSize: 14,
                textData: _authController.userLocation.value,
                fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonView() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(
            left: 16.0.sp, top: 10.h, right: 16.w, bottom: 20.h),
        child: CommonComponents().commonButton(
          text: 'Update',
          onPressed: () {
            _profileController.updateProfileInfo();
          },
          disabled: _profileController.isProfileUpdateLoading.value,
          isLoading: _profileController.isProfileUpdateLoading.value,
        ),
      ),
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

  void _showPhoneBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0.w,
            right: 16.0.w,
            top: 16.0.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonComponents().printText(
                    fontSize: 16,
                    textData: 'Set Your Phone Number',
                    fontWeight: FontWeight.w600),
                SizedBox(height: 10.h),
                _buildPhoneTextFiled(),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    _authController.updatePhoneNumber();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.primaryColor,
                  ),
                  child: CommonComponents().printText(
                      fontSize: 16,
                      textData: 'Update',
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLocationSelectionSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: ColorHelper.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0.sp),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose your location',
                          style: StyleHelper.heading,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      style: StyleHelper.regular14,
                      controller: _authController.searchCityController.value,
                      onChanged: (value) {
                        _authController.onSearchTextChanged(value);
                      },
                      cursorColor: ColorHelper.primaryColor,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: StyleHelper.regular14,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorHelper.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                              BorderSide(color: ColorHelper.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: ColorHelper.primaryColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(() => SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                              itemCount: _authController.suggestions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    _authController.placeName.value =
                                        _authController.suggestions[index]
                                            ["description"];

                                    _authController.updateLocation();
                                  },
                                  child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.location_on_outlined,
                                        color: ColorHelper.primaryColor,
                                      ),
                                      trailing: CommonComponents().printText(
                                          fontSize: 12,
                                          textData: "",
                                          fontWeight: FontWeight.bold),
                                      title: CommonComponents().printText(
                                          fontSize: 14,
                                          maxLine: 2,
                                          textData:
                                              _authController.suggestions[index]
                                                  ["description"],
                                          fontWeight: FontWeight.bold)),
                                );
                              }),
                        )),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
