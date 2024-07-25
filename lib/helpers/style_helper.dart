import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyleHelper {
  static final TextStyle heading = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle body = GoogleFonts.inter(
    color: Colors.black,
    fontSize: 14.sp,
  );
}
