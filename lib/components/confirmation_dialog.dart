import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../helpers/color_helper.dart';
import 'common_components.dart';

void showConfirmationDialog(
    {required String title,
    required VoidCallback onPressConfirm,
    required VoidCallback onPressCancel, required var controller}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Obx(
        () => AlertDialog(
          backgroundColor: ColorHelper.bgColor,
          title: CommonComponents().printText(
              fontSize: 12, textData: title, fontWeight: FontWeight.bold),
          content: Container(
            height: 30.h,
            child: controller.actionStarted.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorHelper.primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : CommonComponents().printText(
                    fontSize: 12,
                    textData: 'Are you sure?',
                    fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
                onPressed: onPressCancel,
                child: CommonComponents().printText(
                    fontSize: 12,
                    textData: 'Cancel',
                    fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: onPressConfirm,
                child: CommonComponents().printText(
                    fontSize: 12,
                    textData: 'Confirm',
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
    },
  );
}
