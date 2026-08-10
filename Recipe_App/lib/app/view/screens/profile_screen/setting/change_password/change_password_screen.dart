import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';

import '../../../meal_plan/controller/meal_plan_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final InfoController controller = Get.find<InfoController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MealPlanController testController = Get.find<MealPlanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: AppStrings.changePassword.tr,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Obx(() {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //current password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.currentPassword.tr,
                      hinText: AppStrings.enterCurrentPassword.tr,
                      controller: controller.oldPasswordController,
                      validator: Validators.passwordValidator),

                  //New Password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.newPassword.tr,
                      hinText: AppStrings.enterNewPassword.tr,
                      controller: controller.newPasswordController,
                      validator: Validators.passwordValidator),

                  //retype password
                  CustomFromCard(
                    isBorderColor: true,
                    isPassword: true,
                    title: AppStrings.retypePassword.tr,
                    hinText: AppStrings.retypeNewPassword.tr,
                    controller: controller.confirmPasswordController,
                    validator: (value) {
                      return Validators.confirmPasswordValidator(
                          value, controller.newPasswordController.text);
                    },
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  //=====================Change password Button===============

                  controller.isChange.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {

                            if (_formKey.currentState!.validate()) {
                              controller.changePassword(context);
                            }
                          },
                          title: AppStrings.changePassword.tr,
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
