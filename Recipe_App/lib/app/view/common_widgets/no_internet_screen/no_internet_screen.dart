import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg500,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 100.h,),

            Assets.images.noInternet.image(),
            const CustomText(
              top: 12,
              text: "Woops",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.gray,
              bottom:12 ,
            ), const CustomText(
              text: "No Internet",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.gray,
              maxLines: 2,
            ),
            SizedBox(height: 24.h,),

            ///=====================TryAgain Button===================
            CustomButton(
              onTap:onTap,
              title: "Try Again",
            )
          ],
        ),
      ),
    );
  }
}
