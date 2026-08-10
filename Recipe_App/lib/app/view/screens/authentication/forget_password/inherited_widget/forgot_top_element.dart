import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class ForgetTopElement extends StatelessWidget {
  const ForgetTopElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Assets.images.forget.image(fit: BoxFit.cover),
          CustomText(
            text: AppStrings.forgotPasswords.tr,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
            color: AppColors.green900,
          ),
          CustomText(
            top: 10.h,
            maxLines: 4,
            text: AppStrings.enterYourEmailAnd.tr,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.black300,
          ),
        ],
      ),
    );
  }
}
