import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indrive/helpers/style_helper.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Widget? icon;
  final Color? color;

  const CommonButton({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: 8.w),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: StyleHelper.heading,
          ),
        ],
      ),
    );
  }
}
