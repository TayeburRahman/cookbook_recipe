import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_rich_text/custom_rich_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'inherited_widget/top_element.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                  //================Top Element=============
                  const TopElement(),
                  SizedBox(height: 38.h),

                  /// Email Field
                  CustomFromCard(
                    hinText: AppStrings.enterYourEmailHere.tr,
                    title: AppStrings.email.tr,
                    controller: authController.emailController,
                    validator: Validators.emailValidator,
                  ),

                  /// Password Field
                  CustomFromCard(
                    isPassword: true,
                    hinText: AppStrings.enterYourPassword.tr,
                    title: AppStrings.password.tr,
                    controller: authController.passwordController,
                    validator: Validators.passwordValidator,
                  ),

                  /// Remember Me & Forgot Password
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: authController.isRemember.value,
                            checkColor: AppColors.white,
                            activeColor: AppColors.green,
                            onChanged: (value) {
                              authController.isRemember.value = value ?? false;
                              // debugPrint(
                              //     "Checkbox clicked, Remember value: ${authController.isRemember.value}");
                            },
                          )),
                      CustomText(
                        text: AppStrings.rememberMe.tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.forgetPasswordScreen,
                          );
                        }, // Navigate to Forgot Password screen
                        child: CustomText(
                          maxLines: 2,
                          text: AppStrings.forgotPasswords.tr,
                          // fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  //>>>>>>>✅✅Sign In Button✅✅<<<<<<<<

                  authController.isSignInLoading.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              authController.signIn();
                            }
                          },
                          title: AppStrings.signIn.tr,
                        ),
                  // Extra

                  SizedBox(height: 20.h),
                  // if (kDebugMode)
                  CustomButton(
                    onTap: () {
                      authController.emailController.text =
                          "nejage1835@muhaos.com";
                      authController.passwordController.text =
                          "nejage1835@muhaos.com";
                      authController.isRemember.value = true;
                    },
                    title: "Demo Sign In",
                  ),
                  // CustomButton(
                  //   onTap: () {
                  //     authController.emailController.text =
                  //         "nurullahasan.dev@gmail.com";
                  //     authController.passwordController.text = "111111";
                  //     authController.isRemember.value = true;
                  //   },
                  //   title: "Demo Sign In 2 ",
                  // ),
                  // // End
                  SizedBox(height: 50.h),

                  /// Don't have an account? Sign Up
                  CustomRichText(
                    firstText: AppStrings.dontHaveAnAccount.tr,
                    secondText: AppStrings.signUp.tr,
                    onTapAction: () {
                      AppRouter.route.pushNamed(
                        RoutePath.signUpScreen,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
