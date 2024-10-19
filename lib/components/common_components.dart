import 'dart:io';

import 'package:callandgo/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:callandgo/helpers/color_helper.dart';
import 'package:callandgo/helpers/space_helper.dart';
import 'package:get/get.dart';

class CommonComponents {
  Widget printText(
      {required int fontSize,
      required String textData,
      required FontWeight fontWeight,
      Color? color = Colors.white,
      int maxLine = 1}) {
    return Text(
      textData,
      textAlign: TextAlign.start,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: fontWeight, fontSize: fontSize.sp, color: color),
    );
  }

  Widget addPhotoInfo(
      {required String title,
      String? imgPath,
      Color? color,
      required String buttonText,
      required VoidCallback onButtonPressed,
      List<String>? instructions,
      required bool isLoading}) {
    // Use an empty list if instructions is null
    final List<String> instructionsList = instructions ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpaceHelper.verticalSpace5,
          printText(
            fontSize: 14,
            textData: title,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          if (imgPath != null)
            imgPath.contains('assets')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Image.asset(
                        imgPath,
                        height: 150.h,
                        width: 150.w,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Image.file(
                        File(imgPath),
                        height: 150.h,
                        width: 150.w,
                        color: color,
                      ),
                    ),
                  ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.w),
            child: commonAddPhotoButton(
                text: buttonText,
                onPressed: onButtonPressed,
                isLoading: isLoading,
                disabled: isLoading ? true : false),
          ),
          SpaceHelper.verticalSpace10,
          for (var instruction in instructionsList)
            _buildTextView(txt: instruction),
          SpaceHelper.verticalSpace15,
        ],
      ),
    );
  }

  Widget _buildTextView({required String txt}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: RichText(
        softWrap: true,
        text: TextSpan(
          children: [
            TextSpan(
              text: '• ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: txt,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildRouteStatusIcon(String currentStatus) {
    if (currentStatus == "Pending") {
      return Icon(
        Icons.pending_outlined,
        size: 24.sp,
        color: Colors.red,
      );
    } else if (currentStatus == "OnGoing") {
      return Icon(
        Icons.add_road_rounded,
        size: 24.sp,
        color: ColorHelper.primaryColor,
      );
    } else {
      return Icon(
        Icons.check_circle_outline,
        size: 24.sp,
        color: Colors.green,
      );
    }
  }

  void showRoutesDialog(BuildContext context, var routes, bool onGoing) {
    HomeController homeController=Get.find();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorHelper.bgColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child:  Padding(
            padding:  EdgeInsets.all(13.sp),
            child: Container(
              width: double.maxFinite,
              height: 100.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 160.w,
                          child: CommonComponents().printText(
                              fontSize: 15,
                              textData: "${routes[index].destinationPoint}",
                              fontWeight: FontWeight.bold),
                        ),
                        onGoing?
                        buildRouteStatusIcon(routes[index].currentStatus):
                        CommonComponents().printText(
                            fontSize: 10,
                            textData: "${homeController.calculateDistance(
                                point1: routes[index].pickupLatLng,
                                point2: routes[index].destinationLatLng)}",
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }


  Widget commonButton({
    required text,
    required VoidCallback onPressed,
    bool disabled = false,
    Icon? icon,
    String? imagePath,
    double borderRadius = 24,
    double fontSize = 16,
    double paddingVertical=12,
    double paddingHorizontal=24,
    Color color = ColorHelper.primaryColor,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: paddingVertical.h, horizontal: paddingHorizontal.w),
        decoration: BoxDecoration(
          color: disabled
              ? ColorHelper.lightGreyColor
              : color, // Change this to your desired color
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        child: Center(
          child: isLoading
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHelper.whiteColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ??
                        (imagePath != null
                            ? Image.asset(imagePath)
                            : const SizedBox()),
                    SpaceHelper.horizontalSpace5,
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: fontSize.sp, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget commonAddPhotoButton({
    required text,
    required VoidCallback onPressed,
    bool disabled = false,
    double borderRadius = 24,
    double fontSize = 16,
    Color color = const Color(0xFF004AAD),
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget commonTextPicker(
      {required String labelText,
      required TextEditingController textController,
      Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SpaceHelper.verticalSpace5, // Space between text and text field
          TextField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          SpaceHelper.verticalSpace5,
        ],
      ),
    );
  }

  Widget customTab(String text, IconData icon) {
    return Tab(
      height: 40.h,
      iconMargin: EdgeInsets.all(5.sp),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SpaceHelper.verticalSpace3,
          Text(
            text,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget CommonCard({
    required BuildContext context,
    required IconData icon,
    required String number,
    required String text,
    Color? iconColor,
    Color textColor = Colors.black,
    Color? cardColor,
    bool isDescription = false,
  }) {
    return SizedBox(
      child: Card(
        color: cardColor ?? ColorHelper.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              if (isDescription) ...[
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            color: iconColor ?? ColorHelper.primaryColor,
                            size: 20.w,
                          ),
                          SpaceHelper.horizontalSpace3,
                          CommonComponents().printText(
                            fontSize: 16,
                            textData: text,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      CommonComponents().printText(
                        fontSize: 14,
                        textData: number,
                        maxLine: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        color: iconColor ?? ColorHelper.primaryColor,
                        size: 30.w,
                      ),
                    ),
                    SingleChildScrollView(
                      child: CommonComponents().printText(
                        fontSize: 18,
                        maxLine: 3,
                        textData: number.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CommonComponents().printText(
                      fontSize: 14,
                      textData: text,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
