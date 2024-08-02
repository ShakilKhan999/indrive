import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';

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
                ? Image.asset(
                    imgPath,
                    height: 150.h,
                    width: 150.w,
                  )
                : Image.file(
                    File(imgPath),
                    height: 150.h,
                    width: 150.w,
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

  Widget commonButton(
      {required text,
      required VoidCallback onPressed,
      bool disabled = false,
      Icon? icon,
      String? imagePath,
      double borderRadius = 24,
      double fontSize = 16,
      Color color = const Color(0xFF004AAD)}) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: disabled
              ? ColorHelper.lightGreyColor
              : color, // Change this to your desired color
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        child: Center(
          child: Row(
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
      required TextEditingController textController}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
}
