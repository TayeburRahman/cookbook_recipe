import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/date_converter/date_converter.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_nav_bar/custom_nav_bar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';
import '../profile_screen/my_recipe/controller/my_recipe_controller.dart';
import 'inner_widget/custom_section.dart';
import 'inner_widget/featured_section.dart';
import 'inner_widget/prep_section.dart';
import 'inner_widget/weekly_section.dart';

class MealPlanSection extends StatefulWidget {
  const MealPlanSection({super.key});

  @override
  State<MealPlanSection> createState() => _MealPlanSectionState();
}

class _MealPlanSectionState extends State<MealPlanSection> {
  int selectedIndex = -1;
  int selectedIndexBeforePrep = 0;

  final MealPlanController controller = Get.find<MealPlanController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final MyRecipeController myRecipeController = Get.find<MyRecipeController>();

  @override
  void initState() {
    super.initState();
    profileController.getProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeDefaultMealPlan();
    });
  }

  Future<void> _initializeDefaultMealPlan() async {
    if (controller.selectedPlan != null) {
      setState(() {
        selectedIndex = 0;
        selectedIndexBeforePrep = 0;
      });
      controller.getWeeklyMealPlan(id: controller.selectedPlan!.id ?? "");
      return;
    }

    await controller.getWeeklyPlan();
    final plans = controller.weeklyPlanData.value.plans;
    if (plans != null && plans.isNotEmpty) {
      final defaultPlan = plans.first;
      setState(() {
        selectedIndex = 0;
        selectedIndexBeforePrep = 0;
        controller.selectedPlan = defaultPlan;
      });
      controller.getWeeklyMealPlan(id: defaultPlan.id ?? "");
    } else {
      CommonFilterBox.weeklyBox(context, (plan) {
        setState(() {
          selectedIndex = 0;
          selectedIndexBeforePrep = 0;
          controller.selectedPlan = plan;
        });
        controller.getWeeklyMealPlan(id: plan.id ?? "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      //====================Plans================
      appBar: CustomAppBar(
        appBarContent: AppStrings.plans.tr.toUpperCase(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: CustomText(
                      text:
                          "${DateConverter.getGreetingMessage().tr}, ${profileController.profileModel.value.name}",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      bottom: 10.h,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    //==============@@Weekly@@=============
                    GestureDetector(
                      onTap: () {
                        CommonFilterBox.weeklyBox(context, (plan) {
                          setState(() {
                            selectedIndexBeforePrep = 0;
                            selectedIndex = 0;
                            controller.selectedPlan = plan;
                          });
                          controller.getWeeklyMealPlan(id: plan.id ?? '');
                        });
                      },
                      child: Row(
                        children: [
                          Assets.icons.calender.svg(
                            colorFilter: ColorFilter.mode(
                              selectedIndex == 0
                                  ? AppColors.green
                                  : AppColors.black500,
                              BlendMode.srcIn,
                            ),
                          ),
                          CustomText(
                            left: 4,
                            text: AppStrings.weekly.tr.toUpperCase(),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == 0
                                ? AppColors.green
                                : AppColors.black500,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 20.sp,
                            color: selectedIndex == 0
                                ? AppColors.green
                                : AppColors.black500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),

                    //==============Custom=============

                    GestureDetector(
                      onTap: () {
                        CommonFilterBox.showCustomDialog(context,
                            (customPlanList) {
                          setState(() {
                            selectedIndexBeforePrep = 1;
                            selectedIndex = 1;
                            controller.selectedCustomPlanList = customPlanList;
                          });
                          controller.getWeeklyMealPlan(
                              id: customPlanList.id ?? '');
                        });
                      },
                      child: Row(
                        children: [
                          CustomText(
                            text: AppStrings.custom.tr.toUpperCase(),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == 1
                                ? AppColors.green
                                : AppColors.black500,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 20.sp,
                            color: selectedIndex == 1
                                ? AppColors.green
                                : AppColors.black500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),

                    GestureDetector(
                      onTap: () {
                        CommonFilterBox.featureBox(context, (selectedPlan) {
                          setState(() {
                            selectedIndexBeforePrep = 2;
                            selectedIndex = 2;
                            controller.selectedFeaturePlanList = selectedPlan;
                          });
                          controller.getWeeklyMealPlan(
                              id: selectedPlan.id ?? '');
                        });
                      },
                      child: Row(
                        children: [
                          CustomText(
                            text: AppStrings.featured.tr.toUpperCase(),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == 2
                                ? AppColors.green
                                : AppColors.black500,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 20.sp,
                            color: selectedIndex == 2
                                ? AppColors.green
                                : AppColors.black500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),

                    //==============Prep=============

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                      child: CustomText(
                        text: AppStrings.prep.tr.toUpperCase(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == 3
                            ? AppColors.green
                            : AppColors.black500,
                        right: 8.w,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(width: double.infinity, child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (selectedIndex == 0) {
      return WeeklySection(controller: controller, context: context);
    } else if (selectedIndex == 1) {
      return CustomSection(controller: controller, context: context);
    } else if (selectedIndex == 2) {
      return FeaturedSection(controller: controller, context: context);
    } else if (selectedIndex == 3) {
      return PrepSection(
          controller: controller,
          selectedIndexBeforePrep: selectedIndexBeforePrep);
    } else {
      return const SizedBox();
    }
  }
}
