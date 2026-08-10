import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg500,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              CustomText(
                text: AppStrings.getStarted.tr,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: AppColors.green900,
              ),
              CustomText(
                text: AppStrings.startWithSignUpOr.tr,
                fontWeight: FontWeight.w300,
                fontSize: 20.sp,
                color: AppColors.black300,
              ),
              Assets.images.recipe.image(),
              CustomText(
                text: AppStrings.aGreatIsNotJustAbout.tr,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                maxLines: 20,
                color: AppColors.black300,
                bottom: 10.h,
              ),

              ///===================Sign In Screen=================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomButton(
                  onTap: () {
                    AppRouter.route.pushNamed(RoutePath.signInScreen);
                  },
                  title: AppStrings.signIn.tr,
                  fillColor: AppColors.green900,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              ///===================SignUp=================

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomButton(
                  onTap: () {
                    AppRouter.route.pushNamed(RoutePath.signUpScreen);
                  },
                  title: AppStrings.signUp.tr,
                  fillColor: AppColors.green900,
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
