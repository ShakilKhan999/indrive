// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/helpers/space_helper.dart';

class CommonComponents {
  Widget CommonButton(
      {required String text,
      required VoidCallback onPressed,
      bool disabled = false,
      Icon? icon,
      String? imagePath,
      double borderRadius = 24,
      double fontSize = 16}) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey
              : Colors.green, // Change this to your desired color
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

  Widget CommonTextPicker(
      {required String labelText,
      required TextEditingController textController}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 16,
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
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          SpaceHelper.verticalSpace5,
        ],
      ),
    );
  }
}
