import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class GoalSettingsScreen extends StatelessWidget {
  GoalSettingsScreen({super.key});

  final AuthController _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      //=================Appbar=================
      appBar: CustomAppBar(
        appBarContent: AppStrings.goalSetting.tr,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              children: [
                Assets.images.goalIcon.image(),

                CustomText(
                  text: AppStrings.whatsYourGoal.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  color: AppColors.green,
                ),

                CustomText(
                  top: 10.h,
                  text: AppStrings.setYourGoalAndLet.tr,
                  fontWeight: FontWeight.w400,
                  maxLines: 10,
                  fontSize: 15.sp,
                  color: AppColors.green,
                ),
                //========================Goal================
                Column(
                  children: _controller.goal.map((preference) {
                    return CheckboxListTile(
                      title: Text(preference
                              .toString()
                              .split('_')
                              .join(' ')
                              .capitalize ??
                          "N/A"),
                      value: _controller.selectGoal.contains(preference),
                      onChanged: (bool? value) {
                        _controller.toggleGoalPreference(preference, value!);
                      },
                    );
                  }).toList(),
                ),

                SizedBox(
                  height: 100.h,
                ),

                //=====================Continues Button===================

                _controller.isUpdateInfo.value
                    ? const CustomLoader()
                    : CustomButton(
                        onTap: () {
                          if (_controller.selectGoal.isEmpty) {
                            toastMessage(message: "Please Select Your Goal");
                          } else {
                            _controller.updateInfo();
                            // _controller.signUp();
                          }

                          // AppRouter.route.pushNamed(RoutePath.subscriptionPlanScreen);
                          //   AppRouter.route.pushNamed(
                          //       RoutePath.otpScreen,extra: {"isForget":false}
                          //   );
                        },
                        title: AppStrings.submit.tr,
                      ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
