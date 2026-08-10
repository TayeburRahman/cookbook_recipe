import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomDietCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final double elevation;

  const CustomDietCard({
    super.key,
    required this.title,
    required this.icon,
    this.color = Colors.white,
    this.elevation = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: AppColors.greyLight.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.bg500.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 32.w,
              height: 32.w,
              child: Center(
                child: Image.asset(
                  icon,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              // child: Center(child: icon),
            ),
          ),
          SizedBox(height: 6.h),
          CustomText(
            maxLines: 2,
            text: title,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
