import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

 class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 48,
    this.width = double.maxFinite,
    required this.onTap,
    this.title = 'Welcome',
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.fillColor = AppColors.green,
    this.textColor = AppColors.white,
    this.borderColor = Colors.transparent,
    this.isRadius = false,
    this.shadowColor = AppColors.green,
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlurRadius = 8.0,
    this.isLoading = false,
  });

  final double height;
  final double width;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final bool isRadius;
  final VoidCallback? onTap;
  final String title;
  final double marginVertical;
  final double marginHorizontal;
  final Color shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: marginVertical,
          horizontal: marginHorizontal,
        ),
        alignment: Alignment.center,
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(color: borderColor),
          borderRadius:
          isRadius ? BorderRadius.circular(25.r) : BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: shadowOffset,
              blurRadius: shadowBlurRadius,
            ),
          ],
        ),
        child: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            color: textColor,
            strokeWidth: 2,
          ),
        )
            : CustomText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
          textAlign: TextAlign.center,
          text: title,
        ),
      ),
    );
  }
}
