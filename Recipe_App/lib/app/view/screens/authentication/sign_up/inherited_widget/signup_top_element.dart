import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class SignUpTopElement extends StatelessWidget {
  const SignUpTopElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomText(
            text: AppStrings.hello.tr,
            fontWeight: FontWeight.w500,
            fontSize: 22.sp,
            color: AppColors.green900,
          ),
          CustomText(
            maxLines: 4,
            top: 10.h,
            text: "welcome to the Koumanis diet meal planner app".tr,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.black300,
          ),
        ],
      ),
    );
  }
}