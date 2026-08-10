import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../../meal_plan/controller/meal_plan_controller.dart';
import '../../meal_plan/models/get_custom_plan.dart';
import '../../meal_plan/models/get_weekly_model.dart';

class GroceryDialog {
  //==============>>>>>>>>>>>>>>>>>>Weekly<<<<<<<<<<<<<<<<<<<====================
  static void weeklyBox(
      BuildContext context, void Function(Plan selectedPlan) onTapPlan) {
    final MealPlanController mealPlanController =
        Get.find<MealPlanController>();

    if (mealPlanController.weeklyPlanData.value.plans == null ||
        mealPlanController.weeklyPlanData.value.plans!.isEmpty) {
      mealPlanController.getWeeklyPlan();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: SizedBox(
            width: 280,
            height: 300,
            child: Obx(() {
              if (mealPlanController.weeklyPlanData.value.plans == null ||
                  mealPlanController.weeklyPlanData.value.plans!.isEmpty) {
                return const Center(child: Text("No weekly plans available."));
              }

              final plans = mealPlanController.weeklyPlanData.value.plans!;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onTapPlan(plan);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      child: Text(
                        plan.weekName ?? "Week ${index + 1}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  //==============>>>>>>>>>>>>>>>>>>Custom<<<<<<<<<<<<<<<<====================
  static void showCustomDialog(
    BuildContext context,
    Function(CustomPlanList) onSave,
  ) async {
    final MealPlanController controller = Get.find<MealPlanController>();
    controller.customPlanList.clear();
    await controller.getCustomPlan();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(16.r),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button, Title...

                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300.h),
                  child: Obx(() {
                    if (controller.customPlanList.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: "No custom plans found.",
                          fontSize: 14.sp,
                          color: AppColors.black,
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.customPlanList.length,
                      itemBuilder: (context, index) {
                        var data = controller.customPlanList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          title: GestureDetector(
                            onTap: () {
                              controller.createdPlanName.value =
                                  data.name ?? "Unnamed Plan";
                              onSave(data);
                              context.pop();
                            },
                            child: CustomText(
                              text: data.name ?? "Unnamed Plan",
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                              color: AppColors.green900,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  //===============Feature Grocery============
}
