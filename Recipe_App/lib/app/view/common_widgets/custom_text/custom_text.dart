import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w300,
    this.color = Colors.green,
    required this.text,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: left.w, right: right.w, top: top.h, bottom: bottom.h),
      child: Text(
        text.tr,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: _getSafeTextStyle(),
      ),
    );
  }

  TextStyle _getSafeTextStyle() {
    try {
      // Attempt to use Google Fonts
      return GoogleFonts.poppins(
        // Use the raw fontSize because you are passing .sp from the screen
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        decorationColor: AppColors.green900,
      );
    } catch (e) {
      // FALLBACK: If Google Fonts fails, use the default system font
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        fontFamily: 'Roboto', // Default system font fallback
      );
    }
  }
}
