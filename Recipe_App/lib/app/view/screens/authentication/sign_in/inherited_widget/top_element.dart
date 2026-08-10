import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class TopElement extends StatelessWidget {
  const TopElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Assets.images.appLogo.image(fit: BoxFit.cover, height: 200.h),
          SizedBox(
            height: 20.h,
          ),
          CustomText(
            text: AppStrings.loginToAccount.tr,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
            color: AppColors.green900,
          ),
          CustomText(
            top: 10.h,
            text: AppStrings.welcomeBackPlease.tr,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.black300,
          ),
        ],
      ),
    );
  }
}
