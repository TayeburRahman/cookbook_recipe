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
import 'package:recipe_app/app/view/screens/authentication/forget_password/inherited_widget/forgot_top_element.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //==================Appbar===================
      appBar: CustomAppBar(
        appBarContent: AppStrings.forgotPassword.tr,
        iconData: Icons.arrow_back,
      ),
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
                  const ForgetTopElement(),
                  SizedBox(height: 38.h),

                  /// Email Field
                  CustomFromCard(
                    hinText: AppStrings.enterYourEmailHere.tr,
                    title: AppStrings.email.tr,
                    controller: authController.emailForgetController,
                    validator: Validators.emailValidator,
                  ),

                  SizedBox(height: 20.h),

                  ///>>>>>>>✅✅Send Code Button✅✅<<<<<<<<

                  authController.isForget.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate() &&
                                !authController.isLoading.value) {
                              authController.forget();
                            }
                          },
                          title: AppStrings.sendCode.tr,
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
