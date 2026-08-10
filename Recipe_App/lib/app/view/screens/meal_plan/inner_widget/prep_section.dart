import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';

import '../../../../core/route_path.dart';
import '../../../../global/helper/string_converter/string_converter.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/enums/status.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../controller/meal_plan_controller.dart';

class PrepSection extends StatelessWidget {
  const PrepSection({
    super.key,
    required this.controller,
    required this.selectedIndexBeforePrep,
  });

  final MealPlanController controller;
  final int selectedIndexBeforePrep;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.rxRequestStatus.value;
      final weeklyMealPlan = controller.weeklyMealPlanData.value;

      // 🔑 Determine planName based on previous selected tab
      String planName = "";
      if (selectedIndexBeforePrep == 0) {
        planName =
            controller.selectedPlan?.weekName ?? AppStrings.selectedWeek.tr;
      } else if (selectedIndexBeforePrep == 1) {
        planName = controller.selectedCustomPlanList?.name ??
            AppStrings.unNamedPlan.tr;
      } else if (selectedIndexBeforePrep == 2) {
        planName =
            controller.selectedFeaturePlanList?.name ?? AppStrings.featured.tr;
      }

      if (status == Status.loading) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      } else if (status == Status.error) {
        return Center(child: Text(AppStrings.failedToLoadWeeklyMealPlan.tr));
      } else if (status == Status.internetError) {
        return Center(child: Text(AppStrings.noInternetFound.tr));
      }

      if (weeklyMealPlan.data == null || weeklyMealPlan.data!.isEmpty) {
        return Center(child: Text(AppStrings.noMealPlanDataAvailable.tr));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Row(
            children: [
              CustomText(
                textAlign: TextAlign.start,
                maxLines: 5,
                text: selectedIndexBeforePrep == 2
                    ? formatPlanName(planName)
                    : planName,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1B3B4A),
                bottom: 10.h,
              ),
              const Spacer(),
              if (selectedIndexBeforePrep == 1)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(RoutePath.prepPreview, extra: {
                        'plan': controller.selectedCustomPlanList,
                        'meals': weeklyMealPlan.data,
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.print,
                              color: Colors.white, size: 16),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: AppStrings.printPrepPlan.tr.toUpperCase(),
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Divider(),
          ...weeklyMealPlan.data!.map((dayData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group recipes by category
                ...() {
                  // Filter out null recipes
                  final validRecipes = dayData.recipes!
                      .where((element) => element.recipe != null)
                      .toList();

                  // Group recipes by category
                  final Map<String, List<dynamic>> groupedByCategory = {};
                  for (var element in validRecipes) {
                    final category =
                        element.recipe!.category?.toString().capitalize ??
                            "N/A";
                    if (!groupedByCategory.containsKey(category)) {
                      groupedByCategory[category] = [];
                    }
                    groupedByCategory[category]!.add(element);
                  }

                  // Build widgets for each category group
                  return groupedByCategory.entries.map((entry) {
                    final categoryName = entry.key;
                    final recipesInCategory = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category header (shown once)
                        () {
                          final cats = categoryName
                              .toString()
                              .split(', ')
                              .where((s) => s.isNotEmpty)
                              .toList();
                          final displayed = cats.take(2).toList();
                          final remaining = cats.length - displayed.length;

                          return Wrap(
                            spacing: 4.w,
                            runSpacing: 4.h,
                            alignment: WrapAlignment.start,
                            children: [
                              ...displayed.map((cat) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.green
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                          color: AppColors.green
                                              .withValues(alpha: 0.2)),
                                    ),
                                    child: CustomText(
                                      text: cat
                                              .replaceAll('-', ' ')
                                              .replaceAll('_', ' ')
                                              .capitalizeFirst ??
                                          cat,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                      color: AppColors.green,
                                    ),
                                  )),
                              if (remaining > 0)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                        color: Colors.black
                                            .withValues(alpha: 0.1)),
                                  ),
                                  child: CustomText(
                                    text: "+$remaining more",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          );
                        }(),
                        SizedBox(height: 8.h),
                        // All recipe prep instructions in this category
                        ...recipesInCategory.map((element) {
                          final recipe = element.recipe!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                fontWeight: FontWeight.w600,
                                text: recipe.name ?? "",
                                color: const Color(0xff1B3B4A),
                                fontSize: 14.sp,
                                bottom: 6.h,
                              ),
                              CustomText(
                                textAlign: TextAlign.start,
                                maxLines: 100,
                                text: recipe.prep ?? "",
                                color: AppColors.black,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        }),
                      ],
                    );
                  }).toList();
                }(),
              ],
            );
          }),
        ],
      );
    });
  }
}
