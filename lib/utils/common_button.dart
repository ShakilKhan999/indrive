import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color color;
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.color,
    required this.text,
    this.icon, // Make icon nullable
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon),
            SizedBox(width: 4.w),
          ],
          Text(text),
        ],
      ),
    );
  }
}
