import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/enums/status.dart';
import '../../../common_widgets/add_meal_card/add_meal_card.dart';
import '../../../common_widgets/custom_swap/custom_swap.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/weekly_recipe_card/weekly_recipe_card.dart';
import '../../../common_widgets/custom_dialoge_alart/custom_dialoge_alart.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';
import '../models/weekly_meal_plan_model.dart';

class WeeklySection extends StatelessWidget {
  const WeeklySection({
    super.key,
    required this.controller,
    required this.context,
  });

  final MealPlanController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    String buildDayNutritionText(RecipeElement? dayNutritional) {
      if (dayNutritional == null) return AppStrings.nutritionNA.tr;
      return '${AppStrings.carbs.tr} : ${dayNutritional.recipe?.nutritional?.carbs ?? 0}';
    }

    String protein(RecipeElement? dayNutritional) {
      if (dayNutritional == null) return AppStrings.nutritionNA.tr;
      return '${AppStrings.protein.tr} : ${dayNutritional.recipe?.nutritional?.protein ?? 0}';
    }

    String fat(RecipeElement? dayNutritional) {
      if (dayNutritional == null) return AppStrings.nutritionNA.tr;
      return '${AppStrings.fat.tr} : ${dayNutritional.recipe?.nutritional?.fat ?? 0}';
    }

    String fiber(RecipeElement? dayNutritional) {
      if (dayNutritional == null) return AppStrings.nutritionNA.tr;
      return '${AppStrings.fiber.tr} : ${dayNutritional.recipe?.nutritional?.fiber ?? 0}';
    }

    String totalProtein(DayNutritional? dayNutritional) {
      if (dayNutritional == null) return "0g";
      return '${dayNutritional.protein?.toStringAsFixed(1) ?? "0"}g';
    }

    String totalCarbs(DayNutritional? dayNutritional) {
      if (dayNutritional == null) return "0g";
      return '${dayNutritional.carbs?.toStringAsFixed(1) ?? "0"}g';
    }

    String totalFat(DayNutritional? dayNutritional) {
      if (dayNutritional == null) return "0g";
      return '${dayNutritional.fat?.toStringAsFixed(1) ?? "0"}g';
    }

    String totalFiber(DayNutritional? dayNutritional) {
      if (dayNutritional == null) return "0g";
      return '${dayNutritional.fiber?.toStringAsFixed(1) ?? "0"}g';
    }

    String totalCalories(DayNutritional? dayNutritional) {
      if (dayNutritional == null) return "0g";
      return '${dayNutritional.calories?.toStringAsFixed(1) ?? "0"}g';
    }

    return Obx(() {
      final status = controller.rxRequestStatus.value;
      final weeklyMealPlan = controller.weeklyMealPlanData.value;

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
          if (controller.selectedPlan != null)
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: controller.selectedPlan!.weekName ??
                        AppStrings.selectedWeek.tr,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    textAlign: TextAlign.start,
                    bottom: 10.h,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(RoutePath.mealPlanPreview);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.print, color: Colors.white, size: 16),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: AppStrings.printPlan.tr.toUpperCase(),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                // Add Delete Button
                GestureDetector(
                  onTap: () {
                    CustomDialogAlert.showDeleteDialog(
                      context,
                      Obx(() {
                        return controller.isResetLoading.value
                            ? const CustomLoader()
                            : ElevatedButton(
                                onPressed: () {
                                  controller.resetMealPlan(
                                    id: controller.selectedPlan!.id ?? "",
                                    context: context,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.green),
                                child: Text(AppStrings.cleanPlan.tr,
                                    style: const TextStyle(
                                        color: AppColors.white)),
                              );
                      }),
                      "Are you sure you want to clean all meals?".tr,
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ...weeklyMealPlan.data!.map((dayData) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //=======>>>>>>>>>>>>>>>>>>>Weekly Option<<<<<<<<<<<<<<<<<<<<
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F3F3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: CustomText(
                      text: dayData.day
                          .toString()
                          .replaceAll('-', ' ')
                          .replaceAll('_', ' ')
                          .toUpperCase(),
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                      textAlign: TextAlign.start,
                      color: const Color(0xff1B3B4A),
                    ),
                  ),

                  SizedBox(
                    height: 12.h,
                  ),
                  // Show Totals Header
                  // Replace the Padding/SingleChildScrollView block with this:
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 8.h),
                  //   child: GridView.count(
                  //     shrinkWrap:
                  //         true, // Important: allows GridView to occupy only needed space
                  //     physics:
                  //         const NeverScrollableScrollPhysics(), // Let the parent handle scrolling
                  //     crossAxisCount:
                  //         4, // Number of columns (adjust to 2 if they feel cramped)
                  //     crossAxisSpacing: 10.w, // Horizontal space between badges
                  //     mainAxisSpacing: 10.h, // Vertical space between badges
                  //     // childAspectRatio:
                  //     //     1.2, // Adjust this to control the height/width ratio
                  //     children: [

                  //     ],
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutritionBadge(
                          AppStrings.protein.tr,
                          totalProtein(dayData.nutritionalTotals),
                          AppColors.green),
                      _buildNutritionBadge(AppStrings.carbs.tr,
                          totalCarbs(dayData.nutritionalTotals), Colors.orange),
                      _buildNutritionBadge(AppStrings.fat.tr,
                          totalFat(dayData.nutritionalTotals), AppColors.red),
                      _buildNutritionBadge(AppStrings.fiber.tr,
                          totalFiber(dayData.nutritionalTotals), Colors.blue),
                      _buildNutritionBadge(
                          AppStrings.calories.tr,
                          totalCalories(dayData.nutritionalTotals),
                          Colors.green),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  if (dayData.recipes == null || dayData.recipes!.isEmpty)
                    AddMealCard(
                      onTap: () async {
                        final planId = controller.selectedPlan?.id;
                        final planName = controller.selectedPlan?.weekName;
                        final day = dayData.day;

                        final result = await context.pushNamed(
                          RoutePath.recipeBox,
                          extra: {
                            "planId": planId,
                            "day": day,
                            "planName": planName,
                          },
                        );

                        if (result == true) {
                          // No manual refresh needed, handled by controller
                        }
                      },
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1️⃣ Group recipes by category
                        ...() {
                          // Filter out null recipes
                          final validRecipes = dayData.recipes!
                              .where((element) => element.recipe != null)
                              .toList();

                          // Group recipes by category
                          final Map<String, List<RecipeElement>>
                              groupedByCategory = {};
                          for (var element in validRecipes) {
                            final category =
                                (element.recipe!.category?.isNotEmpty == true)
                                    ? element.recipe!.category!.join(", ")
                                    : "N/A";
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
                                  final remaining =
                                      cats.length - displayed.length;

                                  return Wrap(
                                    spacing: 4.w,
                                    runSpacing: 4.h,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      ...displayed.map((cat) => Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.green
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
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
                                            color: Colors.black
                                                .withValues(alpha: 0.05),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
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
                                // All recipes in this category
                                ...recipesInCategory.map((element) {
                                  final recipe = element.recipe!;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: WeeklyRecipeCard(
                                      fat: fat(element),
                                      fiver: fiber(element),
                                      carbs: buildDayNutritionText(element),
                                      protein: protein(element),
                                      imageUrl: "${recipe.image}",
                                      title: recipe.name ?? "",
                                      category:
                                          recipe.category?.join(", ") ?? "",
                                      rating: recipe.ratting ?? 0.0,
                                      onCardTap: () {
                                        final myRecipeController = Get.find<MyRecipeController>();
                                        context.pushNamed(
                                          RoutePath.recipeDetails,
                                          extra: {
                                            "id": recipe.id ?? "",
                                            "isExist": myRecipeController.favorites[recipe.id]?.value ?? false,
                                          },
                                        );
                                      },
                                      onMoreTap: () {
                                        showOptionDialog(
                                          context: context,
                                          options: [
                                            OptionItem(
                                              icon: Icons.swap_horiz,
                                              text: AppStrings.swapOut.tr,
                                              onTap: () async {
                                                final result = await AppRouter
                                                    .route
                                                    .pushNamed(
                                                  RoutePath.recipeBox,
                                                  extra: {
                                                    'recipeId': recipe.id,
                                                    'day': dayData.day,
                                                    'planId': controller
                                                        .selectedPlan?.id,
                                                    "isSwap": true
                                                  },
                                                );

                                                if (result == true) {
                                                  // No manual refresh needed, handled by controller
                                                }
                                                context.pop();
                                              },
                                            ),
                                            OptionItem(
                                              icon: Icons.delete,
                                              text: AppStrings.remove.tr,
                                              onTap: () {
                                                controller.swapRemove(
                                                  removeId: recipe.id ?? '',
                                                  day: dayData.day ?? "",
                                                  planId: controller
                                                          .selectedPlan?.id ??
                                                      "",
                                                  context: context,
                                                );
                                              },
                                            ),
                                            OptionItem(
                                              icon: Icons.close,
                                              text: AppStrings.close.tr,
                                              onTap: () {
                                                context.pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }),
                                SizedBox(height: 12.h),
                              ],
                            );
                          }).toList();
                        }(),
                        AddMealCard(
                          onTap: () async {
                            final planId = controller.selectedPlan?.id;
                            final planName = controller.selectedPlan?.weekName;
                            final day = dayData.day;

                            final result = await context.pushNamed(
                              RoutePath.recipeBox,
                              extra: {
                                "planId": planId,
                                "day": day,
                                "planName": planName,
                              },
                            );

                            if (result == true) {
                              // No manual refresh needed, handled by controller
                            }
                          },
                        ),
                      ],
                    ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }

  Widget _buildNutritionBadge(String label, String value, Color color) {
    return Flexible(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label.tr,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: color,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: value.tr,
              fontSize: 11.sp,
              color: AppColors.black300,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
