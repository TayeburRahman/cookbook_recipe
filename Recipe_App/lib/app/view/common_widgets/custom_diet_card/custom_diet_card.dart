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
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.bottomNabColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 32.w,
              height: 32.w,
              child: Center(
                child: Image.asset(
                  icon,
                  height: 28.h,
                  width: 28.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          CustomText(
            maxLines: 2,
            text: title,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
