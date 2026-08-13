import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/weekly_recipe_card/weekly_recipe_card.dart';
import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../global/helper/string_converter/string_converter.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/enums/status.dart';
import '../../../common_widgets/add_meal_card/add_meal_card.dart';
import '../../../common_widgets/custom_swap/custom_swap.dart';
import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/custom_dialoge_alart/custom_dialoge_alart.dart';
import '../../../common_widgets/custom_loader/custom_loader.dart';
import '../controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({
    super.key,
    required this.controller,
    required this.context,
  });

  final MealPlanController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: formatPlanName(
                      controller.selectedFeaturePlanList?.name ??
                          AppStrings.unNamedPlan.tr),
                  bottom: 10.h,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black500,
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
                      return controller.isCleanLoading.value
                          ? const CustomLoader()
                          : ElevatedButton(
                              onPressed: () {
                                controller.cleanMealPlan(
                                  id: controller.selectedFeaturePlanList?.id ??
                                      '',
                                  context: context,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green),
                              child: Text(AppStrings.cleanPlan.tr,
                                  style:
                                      const TextStyle(color: AppColors.white)),
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
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white, size: 16),
                    ],
                  ),
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
                  if (dayData.recipes == null || dayData.recipes!.isEmpty)
                    AddMealCard(
                      onTap: () async {
                        final planId = controller.selectedFeaturePlanList?.id;
                        final day = dayData.day;
                        debugPrint("Sending Plan ID: $planId");
                        debugPrint("Sending Day: $day");

                        final result = await context.pushNamed(
                          RoutePath.recipeBox,
                          extra: {
                            "planId": planId,
                            "day": day,
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
                        // Group recipes by category
                        ...() {
                          // Filter out null recipes
                          final validRecipes = dayData.recipes!
                              .where((element) => element.recipe != null)
                              .toList();

                          // Group recipes by category
                          final Map<String, List<dynamic>> groupedByCategory =
                              {};
                          for (var element in validRecipes) {
                            final category = element.recipe!.category
                                    ?.toString()
                                    .capitalize ??
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
                                      imageUrl: "${recipe.image}",
                                      title: recipe.name ?? "",
                                      category: recipe.category ?? "",
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
                                                        .selectedFeaturePlanList
                                                        ?.id,
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
                                                          .selectedFeaturePlanList
                                                          ?.id ??
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
                            final planId =
                                controller.selectedFeaturePlanList?.id;

                            final planName =
                                controller.selectedFeaturePlanList?.name;
                            final day = dayData.day;
                            debugPrint("Sending Plan ID: $planId");
                            debugPrint("Sending Day: $day");

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
}
