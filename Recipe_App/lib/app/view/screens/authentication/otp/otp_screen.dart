import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra as Map<String, dynamic>?;
    final bool isForgetValue = extra?['isForget'] ?? false;
    final String email = extra?['email'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.white,

      ///: <<<<<<====== AppBar ======>>>>>>>>
      appBar: CustomAppBar(
        appBarContent: AppStrings.verifyCode.tr,
        iconData: Icons.arrow_back,
      ),

      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 30.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Assets.images.otp.image(fit: BoxFit.cover),

                      ///: <<<<<<====== Header ======>>>>>>>>
                      CustomText(
                        top: 7.h,
                        text: AppStrings.checkYourEmail.tr,
                        fontWeight: FontWeight.w500,
                        fontSize: 22.sp,
                        color: AppColors.black,
                      ),
                      CustomText(
                        textAlign: TextAlign.center,
                        top: 15.h,
                        maxLines: 5,
                        text:
                            "We sent a reset link to $email. Please enter the 6-digit code.",
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 60.h),

                      ///: <<<<<<====== OTP Pin Code Field ======>>>>>>>>
                      PinCodeTextField(
                        textStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 24.sp,
                        ),
                        keyboardType: TextInputType.number,
                        autoDisposeControllers: false,
                        cursorColor: AppColors.black,
                        appContext: context,
                        controller: authController.pinCodeController,
                        onCompleted: (value) {
                          if (isForgetValue == true) {
                            authController.activationCode = value;
                          } else if (isForgetValue == false) {
                            authController.resetCode = value;
                          } else {
                            log('object');
                          }
                        },
                        validator: (value) {
                          if (value == null || value.length != 6) {
                            return "Please enter a 6-digit OTP code";
                          }
                          return null;
                        },
                        autoFocus: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 49.h,
                          fieldWidth: 40,
                          borderWidth: 1.5,
                          activeColor: Colors.green,
                          inactiveColor: Colors.green,
                          selectedColor: Colors.black,
                        ),
                        length: 6,
                        enableActiveFill: false,
                        onChanged: (value) {},
                      ),

                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),

              ///: <<<<<<====== Verify Code Button ======>>>>>>>>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: authController.isSignUpOtp.value ||
                        authController.isForgetOtp.value
                    ? const CustomLoader()
                    : CustomButton(
                        isRadius: false,
                        width: MediaQuery.of(context).size.width,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            if (isForgetValue == true) {
                              authController.signUpVerifyOTP();
                            } else if (isForgetValue == false) {
                              authController.forgetOtp();
                            } else {
                              log('object');
                            }
                          }
                        },
                        title: AppStrings.verifyCode.tr,
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
