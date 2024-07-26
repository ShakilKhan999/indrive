

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/helpers/color_helper.dart';
import 'package:indrive/helpers/space_helper.dart';

class CommonComponents{

  Widget printText({required int fontSize, required String textData, required FontWeight fontWeight, Color? color=Colors.white}){
    return Text(textData,style: TextStyle(fontWeight: fontWeight,fontSize: fontSize.sp, color: color),);
  }



  Widget commonButton({
    required text, required VoidCallback onPressed,  bool disabled=false,
    Icon? icon, String? imagePath, double borderRadius=24, double fontSize=16, Color color=const Color(0xFF004AAD)
  }){
    return GestureDetector(
      onTap:disabled?null: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color:disabled?ColorHelper.lightGreyColor: color, // Change this to your desired color
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? (imagePath!=null?Image.asset(imagePath):const SizedBox()),
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


  Widget commonTextPicker({
  required String labelText, required TextEditingController textController
}){
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
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          SpaceHelper.verticalSpace5,

        ],
      ),
    );
  }



}

