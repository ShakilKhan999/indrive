import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:callandgo/components/common_components.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:callandgo/helpers/style_helper.dart';
import 'package:callandgo/screens/auth_screen/controller/auth_controller.dart';
import 'package:callandgo/screens/auth_screen/views/user_name_screen.dart';

class ConfirmLocationScreen extends StatelessWidget {
  ConfirmLocationScreen({super.key});
  final commonComponents = CommonComponents();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeadingView(),
              const Spacer(),
              _buildBottomButtonView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtonView(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
            child: commonComponents.commonButton(
              text: "Yes, I'm here",
              onPressed: () {
                authController.getUserLocation();
              },
              isLoading: authController.userLocationPicking.value,
              disabled: authController.userLocationPicking.value,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.sp, 0.sp, 20.sp, 30.sp),
            child: commonComponents.commonButton(
              text: 'No',
              color: ColorHelper.greyColor,
              onPressed: () {
                _showLocationSelectionSheet(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingView() {
    return Column(
      children: [
        SpaceHelper.verticalSpace40,
        Image.asset(
          'assets/images/ConfirmLocation_logo.png',
          color: ColorHelper.primaryColor,
          height: 200.h,
          width: 300.w,
        ),
        Obx(() => Text(
              'Are you in ${authController.selectedLocation.value}?',
              style: StyleHelper.heading,
            )),
      ],
    );
  }

  void _showLocationSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                      controller: authController.searchCityController.value,
                      onChanged: (value) {
                        authController.onSearchTextChanged(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: StyleHelper.regular14,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(() => SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                              itemCount: authController.suggestions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    authController.placeName.value =
                                        authController.suggestions[index]
                                            ["description"];

                                    var placeDetails = await authController
                                        .googlePlace.details
                                        .get(authController.suggestions[index]
                                            ["placeId"]);

                                    authController.lat.value = placeDetails!
                                        .result!.geometry!.location!.lat!;
                                    authController.long.value = placeDetails
                                        .result!.geometry!.location!.lng!;
                                    Get.back();
                                    Get.to(() => UserNameScreen(),
                                        transition: Transition.rightToLeft);
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
                                              authController.suggestions[index]
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
