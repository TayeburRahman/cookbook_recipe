import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/meal_plan/models/get_weekly_model.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/recipe_details/controller/recipe_details_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/recipe_box/controller/recipe_box_controller.dart';
import '../../../global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import '../../../global/helper/string_converter/string_converter.dart';
import '../../screens/meal_plan/models/feature_plan_model.dart';
import '../../screens/meal_plan/models/get_custom_plan.dart';
import '../custom_dialoge_alart/custom_dialoge_alart.dart';
import '../custom_loader/custom_loader.dart';
import '../../../utils/enums/status.dart';

class CommonFilterBox {
  //====================Filter Box===============
  static void filterBox({
    required BuildContext context,
    required RecipeBoxController controller,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            )
                          ],
                        ),
                        CustomText(
                          text: AppStrings.filterByIngredients.tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: AppColors.white,
                          maxLines: 2,
                          bottom: 18.h,
                        ),

                        //=====================Meal Type===================
                        Obx(() {
                          return CustomTextField(
                            onTap: controller.toggleDropdown,
                            readOnly: true,
                            hintText: controller.selectedMealTypes.isEmpty
                                ? AppStrings.selectMealType.tr
                                : controller.selectedMealTypes.join(', '),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          );
                        }),

                        const SizedBox(height: 20),
                        Obx(() {
                          return controller.isDropdownOpen.value
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        controller.mealOptions.map((meal) {
                                      final isSelected = controller
                                          .selectedMealTypes
                                          .contains(meal);
                                      return ListTile(
                                        title: Text(meal),
                                        trailing: isSelected
                                            ? const Icon(Icons.check,
                                                color: AppColors.green)
                                            : null,
                                        onTap: () {
                                          // log("Ajay Check $meal");
                                          controller.selectMealType(meal);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(); // Hide the dropdown if it's not open
                        }),

                        //=====================Region===================
                        Obx(() {
                          return CustomTextField(
                            onTap: controller.toggleRegionDropdown,
                            readOnly: true,
                            hintText: controller.selectedRegions.isEmpty
                                ? "Select Region"
                                : controller.selectedRegions.join(', '),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          );
                        }),

                        const SizedBox(height: 20),
                        Obx(() {
                          return controller.isRegionOpen.value
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        controller.regionList.map((region) {
                                      final isSelected = controller
                                          .selectedRegions
                                          .contains(region);
                                      return ListTile(
                                        title: Text(region),
                                        trailing: isSelected
                                            ? const Icon(Icons.check,
                                                color: AppColors.green)
                                            : null,
                                        onTap: () {
                                          controller.selectRegion(region);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(); // Hide the dropdown if it's not open
                        }),

                        //=====================Oil===================
                        Obx(() {
                          return CustomTextField(
                            onTap: controller.toggleOilsDropdown,
                            readOnly: true,
                            hintText: controller.selectedOil.value.isEmpty
                                ? AppStrings.oils2.tr
                                : controller.selectedOil.value
                                    .replaceAll('_', ' ')
                                    .split(' ')
                                    .map((word) =>
                                        word[0].toUpperCase() +
                                        word.substring(1))
                                    .join(' '),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          );
                        }),

                        const SizedBox(height: 20),
                        Obx(() {
                          return controller.isOils.value
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: controller.oilsList.map((meal) {
                                      return ListTile(
                                        title: Text(
                                          meal
                                              .replaceAll('_', ' ')
                                              .split(' ')
                                              .map((word) =>
                                                  word[0].toUpperCase() +
                                                  word.substring(1))
                                              .join(' '),
                                        ),
                                        onTap: () {
                                          controller.selectOil(meal);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox();
                        }),

                        //=====================Gain Vs Lost===================
                        Obx(() {
                          return CustomTextField(
                            onTap: controller.toggleGainVSLostDropdown,
                            readOnly: true,
                            hintText: controller.selectGainVsLost.value.isEmpty
                                ? AppStrings.weightLossVsMuscleGain.tr
                                : controller.selectGainVsLost.value
                                    .replaceAll('_', ' ')
                                    .split(' ')
                                    .map((word) =>
                                        word[0].toUpperCase() +
                                        word.substring(1))
                                    .join(' '),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          );
                        }),

                        const SizedBox(height: 20),
                        Obx(() {
                          // If the dropdown is open, show the container with options
                          return controller.isGainVsLost.value
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        controller.gainVsLostList.map((meal) {
                                      return ListTile(
                                        title: Text(
                                          meal
                                              .replaceAll('_', ' ')
                                              .split(' ')
                                              .map((word) =>
                                                  word[0].toUpperCase() +
                                                  word.substring(1))
                                              .join(' '),
                                        ),
                                        onTap: () {
                                          controller.selectGainVSLostOil(meal);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(); // Hide the dropdown if it's not open
                        }),

                        //=====================Whole Food Type===================
                        Obx(() {
                          return CustomTextField(
                            onTap: controller.toggleFoodType,
                            readOnly: true,
                            hintText: controller.selectedFoodTypes.isEmpty
                                ? AppStrings.wholeFoodType.tr
                                : controller.selectedFoodTypes
                                    .map((word) => word
                                        .replaceAll('_', ' ')
                                        .split(' ')
                                        .map((w) => w.isNotEmpty
                                            ? w[0].toUpperCase() +
                                                w.substring(1)
                                            : '')
                                        .join(' '))
                                    .join(', '),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          );
                        }),

                        const SizedBox(height: 20),
                        Obx(() {
                          // If the dropdown is open, show the container with options
                          return controller.isFoodType.value
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        controller.foodTypeList.map((meal) {
                                      final isSelected = controller
                                          .selectedFoodTypes
                                          .contains(meal);
                                      return ListTile(
                                        title: Text(
                                          meal
                                              .replaceAll('_', ' ')
                                              .split(' ')
                                              .map((word) =>
                                                  word[0].toUpperCase() +
                                                  word.substring(1))
                                              .join(' '),
                                        ),
                                        trailing: isSelected
                                            ? const Icon(Icons.check,
                                                color: AppColors.green)
                                            : null,
                                        onTap: () {
                                          controller.selectFoodTypes(meal);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(); // Hide the dropdown if it's not open
                        }),

                        //=====================Flavor Type===================
                        Obx(() {
                          return CustomTextField(
                            onTap: controller.toggleFlavorType,
                            readOnly: true,
                            hintText: controller.selectFlavorType.value.isEmpty
                                ? AppStrings.flavorType.tr
                                : controller.selectFlavorType.value
                                    .replaceAll('_', ' ')
                                    .split(' ')
                                    .map((word) =>
                                        word[0].toUpperCase() +
                                        word.substring(1))
                                    .join(' '),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          );
                        }),

                        const SizedBox(height: 20),
                        Obx(() {
                          // If the dropdown is open, show the container with options
                          return controller.isFlavorType.value
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        controller.flavorTypeList.map((meal) {
                                      return ListTile(
                                        title: Text(
                                          meal
                                              .replaceAll('_', ' ')
                                              .split(' ')
                                              .map((word) =>
                                                  word[0].toUpperCase() +
                                                  word.substring(1))
                                              .join(' '),
                                        ),
                                        onTap: () {
                                          controller.selectFlavorTypes(meal);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(); // Hide the dropdown if it's not open
                        }),

                        CustomText(
                          text: AppStrings.rating.tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 9.sp,
                          color: AppColors.white,
                          bottom: 10.h,
                        ),
                        Obx(() {
                          return Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.updateRating(
                                      index + 1); // Update rating on tap
                                },
                                child: Icon(
                                  Icons.star,
                                  color: index < controller.rating.value
                                      ? Colors.amber
                                      : Colors
                                          .grey, // Highlight the selected stars
                                ),
                              );
                            }),
                          );
                        }),
                        SizedBox(
                          height: 15.h,
                        ),

                        ///: <<<<<<<<<<<<======Prep Time ️>>>>>>>>>>>>>>>>===========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AppStrings.preparationTime.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                AppStrings.setManually.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        Obx(() => RangeSlider(
                              values: controller.prepTimeRange.value,
                              min: 0,
                              max: 200,
                              divisions: 20,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white30,
                              onChanged: (values) {
                                controller.prepTimeRange.value = values;
                              },
                            )),

                        // Labels for start/end
                        Obx(() {
                          final vals = controller.prepTimeRange.value;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${vals.start.round()} mins',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                                Text(
                                  '${vals.end.round()} mins',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          );
                        }),

                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              //controller.callRatingFilter(context);
                              //    controller.getRecipeBoxWithPrepTime(context);
                              ///: <<<<<<<<<<<<======Show recipe ️>>>>>>>>>>>>>>>>===========

                              Obx(() {
                                return CustomButton(
                                  onTap: () {
                                    controller.applyFilters(context);
                                  },
                                  title: AppStrings.showRecipes.tr,
                                  fillColor: AppColors.white,
                                  textColor: AppColors.green,
                                  isLoading: controller.isRatingLoading.value,
                                );
                              }),

                              ///: <<<<<<<<<<<<======Clear All Filter ️>>>>>>>>>>>>>>>>===========

                              GestureDetector(
                                onTap: () {
                                  controller.clearAllFilters();
                                  context.pop();
                                },
                                child: CustomText(
                                  top: 20.sp,
                                  text: AppStrings.clearAllFilters.tr,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp,
                                  color: AppColors.white,
                                  bottom: 10.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  //====================Add===============
  static void addDay({
    required BuildContext context,
    required VoidCallback onTap,
    required String planName,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final MealPlanController controller = Get.find<MealPlanController>();

        final status = controller.rxRequestStatus.value;
        final weeklyMealPlan = controller.weeklyMealPlanData.value;

        if (status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (status == Status.error) {
          return Center(child: Text(AppStrings.failedToLoadWeeklyMealPlan.tr));
        } else if (status == Status.internetError) {
          return Center(child: Text(AppStrings.noInternetFound.tr));
        }

        if (weeklyMealPlan.data == null || weeklyMealPlan.data!.isEmpty) {
          return Center(child: Text(AppStrings.noMealPlanDataAvailable.tr));
        }
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Column(
                  children: [
                    SizedBox(height: 10.w),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColors.black500,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                    CustomText(
                      top: 15,
                      textAlign: TextAlign.center,
                      text: planName,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    SizedBox(height: 20.h),
                    ...weeklyMealPlan.data!.map((dayData) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //=======>>>>>>>>>>>>>>>>>>>Weekly Option<<<<<<<<<<<<<<<<<<<<
                            CustomText(
                              text: "${dayData.day}",
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp,
                              color: AppColors.green,
                              bottom: 8.h,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1️⃣ Mapped recipe cards
                                ...dayData.recipes!
                                    .where((element) => element.recipe != null)
                                    .map((element) {
                                  final recipe = element.recipe!;

                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Row(
                                        children: [
                                          Assets.icons.arrowing.svg(),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          CustomText(
                                            textAlign: TextAlign.start,
                                            text: recipe.name ?? "",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.green,
                                          ),
                                        ],
                                      ));
                                }),

                                SizedBox(
                                  height: 12.h,
                                ),
                              ],
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  context.pop();
                                  onTap();
                                },
                                child: CustomText(
                                  text: "${AppStrings.addTo.tr} ${dayData.day}",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                  color: AppColors.bottomNabColor,
                                  bottom: 8.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //create custom plan

  // Function to handle the creation of the custom plan
  static void reviewDialog(BuildContext context, String recipeId) {
    final RecipeDetailsController controller =
        Get.find<RecipeDetailsController>();
    double userRating = 0; // Local variable to store selected rating

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rating Box Image (optional)
                Assets.images.ratingBox.image(),
                const SizedBox(height: 10),
                // Heading Text
                CustomText(
                  textAlign: TextAlign.center,
                  text: AppStrings.giveRatingOutOf5.tr,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.green900,
                  bottom: 10,
                  maxLines: 2,
                ),

                // ⭐ Rating Bar ⭐
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    userRating = rating;
                    // debugPrint("User selected rating: $rating");
                  },
                ),

                const SizedBox(height: 15),

                // Feedback TextField
                CustomTextField(
                  maxLines: 2,
                  textEditingController: controller.feedBackController,
                  inputTextStyle: const TextStyle(color: AppColors.black),
                  fillColor: AppColors.white,
                  fieldBorderColor: AppColors.green900,
                  hintText: AppStrings.writeYourFeedback.tr,
                ),

                const SizedBox(height: 15),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomButton(
                        onTap: () {
                          controller.feedBackController.text = "";
                          context.pop();
                        },
                        title: AppStrings.cancel.tr,
                        textColor: AppColors.white,
                        fillColor: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Obx(() {
                        return controller.isReview.value
                            ? const CustomLoader()
                            : CustomButton(
                                onTap: () {
                                  if (userRating == 0) {
                                    toastMessage(
                                        message: AppStrings
                                            .pleaseGiveARatingFirst.tr);
                                  } else if (controller.feedBackController.text
                                      .trim()
                                      .isEmpty) {
                                    toastMessage(
                                        message: AppStrings
                                            .pleaseWriteYourFeedback.tr);
                                  } else {
                                    controller.reviewSend(
                                      context: context,
                                      recipeId: recipeId,
                                      rating: userRating,
                                    );
                                  }
                                },
                                title: AppStrings.submit.tr,
                                textColor: AppColors.white,
                                fillColor: AppColors.green,
                              );
                      }),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to handle the creation of the custom plan
  static void resetPlanBox(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: AppStrings.resetPlan.tr,
                  // Updated content text
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: AppColors.green,
                  bottom: 10.h,
                ),
              ),
              CustomText(
                textAlign: TextAlign.start,
                text: AppStrings.cleanPlan.tr,
                // Another piece of content text
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.green,
                bottom: 10.h,
              ),
              CustomText(
                textAlign: TextAlign.start,
                text: AppStrings.printPlan.tr,
                // Another piece of content text
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.green,
                bottom: 10.h,
              ),
              CustomText(
                textAlign: TextAlign.start,
                text: AppStrings.downloadPlan.tr,
                // Another piece of content text
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.green,
                bottom: 10.h,
              ),
            ],
          ),
          // actions: <Widget>[
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop(); // Close the dialog
          //     },
          //     child: const Text("Cancel"),
          //   ),
          // ],
        );
      },
    );
  }

  // Function to handle the creation of the custom plan
  static void swapBox(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Add your desired radius
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Row(
                  children: [
                    Assets.images.filter.image(color: AppColors.green900),
                    CustomText(
                      left: 10.w,
                      textAlign: TextAlign.center,
                      text: AppStrings.swapOut.tr,
                      // Updated content text
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Row(
                  children: [
                    Assets.icons.close.svg(color: AppColors.green900),
                    CustomText(
                      left: 10.w,
                      textAlign: TextAlign.center,
                      text: AppStrings.remove.tr,
                      // Updated content text
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //==============>>>>>>>>>>>>>>>>>>Weekly<<<<<<<<<<<<<<<<<<<====================
  static void weeklyBox(
      BuildContext context, void Function(Plan selectedPlan) onTapPlan) {
    final MealPlanController mealPlanController =
        Get.find<MealPlanController>();

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
              final status = mealPlanController.rxRequestStatus.value;
              if (status == Status.loading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
              if (mealPlanController.weeklyPlanData.value.plans == null ||
                  mealPlanController.weeklyPlanData.value.plans!.isEmpty) {
                return Center(
                    child:
                        CustomText(text: AppStrings.noWeeklyPlansAvailable.tr));
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
    Function(CustomPlanList) onSave, {
    bool showCreateOption = true,
  }) async {
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
                          text: AppStrings.noCustomPlansFound.tr,
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
                                  data.name ?? AppStrings.unNamedPlan.tr;
                              onSave(data);
                              context.pop();
                            },
                            child: CustomText(
                              text: data.name ?? AppStrings.unNamedPlan.tr,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                              color: AppColors.green900,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              CustomDialogAlert.showDeleteDialog(
                                context,
                                Obx(() {
                                  return controller.isDeleteLoading.value
                                      ? const CustomLoader()
                                      : ElevatedButton(
                                          onPressed: () {
                                            controller.planeDelete(
                                              id: data.id ?? "",
                                              context: context,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.green),
                                          child: Text(
                                              AppStrings.deleteMealPlan.tr,
                                              style: const TextStyle(
                                                  color: AppColors.white)),
                                        );
                                }),
                                AppStrings.areYouSureWantToRemoveThisPlan.tr,
                              );
                            },
                            child: const Icon(Icons.delete,
                                color: AppColors.green900),
                          ),
                        );
                      },
                    );
                  }),
                ),

                if (showCreateOption) ...[
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      planNameCreate(
                          context, onSave); // Callback ফাংশনের রেফারেন্স পাঠানো
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: AppColors.green900),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: AppStrings.createCustomPlan.tr,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

//==============>>>>>>>>>>>>>>>>>>Custom<<<<<<<<<<<<<<<<====================

  static void planNameCreate(
    BuildContext context,
    Function(CustomPlanList) onSave,
  ) {
    final MealPlanController mealPlanController =
        Get.find<MealPlanController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: <Widget>[
            SizedBox(height: 20.h),
            CustomText(
              left: 4,
              text: AppStrings.whatWouldYouLikeToNameThisPlan.tr,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.green900,
              bottom: 10.h,
              maxLines: 2,
            ),
            CustomTextField(
              textEditingController: mealPlanController.planNameController,
              inputTextStyle: const TextStyle(color: AppColors.black),
              fillColor: AppColors.white,
              fieldBorderColor: AppColors.green900,
              hintText: AppStrings.yourPlanName.tr,
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    onTap: () {
                      context.pop(); // Close dialog
                    },
                    title: AppStrings.cancel,
                    textColor: AppColors.white,
                    fillColor: Colors.red,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 5,
                  child: Obx(() {
                    return CustomButton(
                      onTap: () async {
                        if (mealPlanController
                            .planNameController.text.isNotEmpty) {
                          await mealPlanController
                              .createCustomPlanMethod(); // ✅ wait for API success
                          await mealPlanController
                              .getCustomPlan(); // ✅ update the list

                          final newPlan =
                              mealPlanController.customPlanList.last;
                          mealPlanController.selectedCustomPlanList = newPlan;
                          mealPlanController.getWeeklyMealPlan(
                              id: newPlan.id!); // ✅ call method

                          onSave(newPlan); // ✅ pass newly created plan
                          context.pop(); // close dialog
                        }
                      },
                      title: mealPlanController.isCreate.value
                          ? AppStrings.saving.tr
                          : AppStrings.save.tr,
                      textColor: AppColors.white,
                      fillColor: AppColors.green,
                    );
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  ///

  static void featureBox(
    BuildContext context,
    void Function(FeaturePlanList selectedFeaturePlan) onTapPlan,
  ) {
    final MealPlanController controller = Get.find<MealPlanController>();

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
              if (controller.featurePlanList.isEmpty) {
                return Center(
                    child: CustomText(
                        text: AppStrings.noFeaturedPlansAvailable.tr));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.featurePlanList.length,
                itemBuilder: (context, index) {
                  final plan = controller.featurePlanList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onTapPlan(plan);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      child: Text(
                        formatPlanName(
                            plan.name ?? "Featured Plan ${index + 1}"),
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

  //=========+Score==========

  static void score(BuildContext context, String recipeId) {
    final RecipeDetailsController controller =
        Get.find<RecipeDetailsController>();
    double userRating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rating Box Image (optional)
                Assets.images.ratingBox.image(),

                const SizedBox(height: 10),

                // Heading Text
                CustomText(
                  textAlign: TextAlign.center,
                  text: AppStrings.giveRatingOutOf5.tr,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.green900,
                  bottom: 10,
                  maxLines: 2,
                ),

                // ⭐ Rating Bar ⭐
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    userRating = rating;
                    // debugPrint("User selected rating: $rating");
                  },
                ),

                const SizedBox(height: 15),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomButton(
                        onTap: () {
                          context.pop();
                        },
                        title: AppStrings.cancel.tr,
                        textColor: AppColors.white,
                        fillColor: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Obx(() {
                        return controller.isScore.value
                            ? const CustomLoader()
                            : CustomButton(
                                onTap: () {
                                  if (userRating == 0) {
                                    toastMessage(
                                        message: AppStrings
                                            .pleaseGiveARatingFirst.tr);
                                  } else {
                                    controller.scoreAdd(
                                      context: context,
                                      recipeId: recipeId,
                                      rating: userRating,
                                    );
                                  }
                                },
                                title: AppStrings.submit.tr,
                                textColor: AppColors.white,
                                fillColor: AppColors.green,
                              );
                      }),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
