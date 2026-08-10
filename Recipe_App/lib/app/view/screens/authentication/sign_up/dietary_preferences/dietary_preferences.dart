import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class DietaryPreferences extends StatelessWidget {
  final AuthController _controller = Get.find<AuthController>();

  DietaryPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      //===================Appbar=================
      appBar: CustomAppBar(
        appBarContent: AppStrings.dietaryPreferences.tr,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStrings.selectAnyRelevantDi.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black500,
                top: 10.h,
                maxLines: 2,
              ),
              //========================preference================
              Obx(() {
                return Column(
                  children: _controller.relevant.map((preference) {
                    return CheckboxListTile(
                      title: Text(preference),
                      value:
                          _controller.selectedPreferences.contains(preference),
                      onChanged: (bool? value) {
                        _controller.togglePreference(preference, value!);
                      },
                    );
                  }).toList(),
                );
              }),
              CustomText(
                text: AppStrings.mealPreferencesSelect.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black500,
                top: 10.h,
                maxLines: 2,
              ),
              //========================mealPreference================
              Obx(() {
                return Column(
                  children: _controller.mailPrefarence.map((mealPreference) {
                    return CheckboxListTile(
                      title: Text(mealPreference),
                      value: _controller.selectedMealPreferences
                          .contains(mealPreference),
                      onChanged: (bool? value) {
                        _controller.toggleMealPreference(
                            mealPreference, value!);
                      },
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: 50.h),

              //========================Continue Button================
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: CustomButton(
                  onTap: () {
                    if (_controller.selectedPreferences.isEmpty) {
                      toastMessage(
                          message:
                              'Please Select At Least One Relevant Dietary preferences');
                    } else if (_controller.selectedMealPreferences.isEmpty) {
                      toastMessage(
                          message: 'Please Select At Least One Meal Types');
                    } else {
                      AppRouter.route.pushNamed(RoutePath.goalSettingsScreen);
                    }
                  },
                  title: AppStrings.continues.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
