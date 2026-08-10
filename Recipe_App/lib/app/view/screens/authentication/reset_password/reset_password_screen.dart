import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      //=================reset Password=================
      appBar: CustomAppBar(
        appBarContent: AppStrings.resetPassword.tr,
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Form(
            key: _formKey,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22.h),
                  Center(
                    child: Column(
                      children: [
                        CustomText(
                          text: AppStrings.setANewPassword.tr,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                          color: AppColors.green900,
                        ),
                        CustomText(
                          top: 10.h,
                          maxLines: 4,
                          text: AppStrings.createANewPasswordEnsureIt.tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: AppColors.black300,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 38.h),

                  /// enterNewPassword Field
                  CustomFromCard(
                    isPassword: true,
                    hinText: AppStrings.enterNewPassword.tr,
                    title: AppStrings.enterNewPassword.tr,
                    controller: authController.resetPasswordController1,
                    validator: Validators.passwordValidator,
                  ),

                  CustomFromCard(
                    isPassword: true,
                    hinText: AppStrings.enterYourPassword.tr,
                    title: AppStrings.confirmPassword.tr,
                    controller: authController.resetPasswordController2,
                    validator: (value) {
                      // Pass the password value for confirmation check
                      return Validators.confirmPasswordValidator(
                          value, authController.resetPasswordController1.text);
                    },
                  ),

                  SizedBox(height: 20.h),

                  ///>>>>>>>✅✅reset Button✅✅<<<<<<<<

                  authController.isResetLoading.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              authController.resetPassword(
                                  email: authController
                                      .emailForgetController.text);
                            }
                          },
                          title: AppStrings.resetPassword.tr,
                        ),

                  SizedBox(height: 50.h),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
