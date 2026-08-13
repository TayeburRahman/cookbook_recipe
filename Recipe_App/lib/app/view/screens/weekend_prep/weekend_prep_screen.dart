import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_nav_bar/custom_nav_bar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';

import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/screens/weekend_prep/controller/weekend_prep_controller.dart';
import 'package:recipe_app/app/view/screens/weekend_prep/models/weekend_prep_model.dart';

class WeekendPrepScreen extends StatefulWidget {
  const WeekendPrepScreen({super.key});

  @override
  State<WeekendPrepScreen> createState() => _WeekendPrepScreenState();
}

class _WeekendPrepScreenState extends State<WeekendPrepScreen> {
  int selectedIndex = 0;
  final MealPlanController controller = Get.find<MealPlanController>();
  final WeekendPrepController weekendPrepController =
      Get.put(WeekendPrepController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      if (controller.selectedPlan != null) {
        setState(() {
          selectedIndex = 0;
        });
        weekendPrepController.getWeekendPrepData(id: controller.selectedPlan!.id ?? '');
        return;
      }

      await controller.getWeeklyPlan();
      final plans = controller.weeklyPlanData.value.plans;
      if (plans != null && plans.isNotEmpty) {
        final defaultPlan = plans.first;
        setState(() {
          selectedIndex = 0;
          controller.selectedPlan = defaultPlan;
        });
        weekendPrepController.getWeekendPrepData(id: defaultPlan.id ?? '');
      } else {
        CommonFilterBox.weeklyBox(context, (plan) {
          setState(() {
            selectedIndex = 0;
            controller.selectedPlan = plan;
          });
          weekendPrepController.getWeekendPrepData(id: plan.id ?? '');
        });
      }
    } catch (e) {
      log("Error From _loadInitialData $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
      appBar: CustomAppBar(
        appBarContent: AppStrings.weekendPrep.tr.toUpperCase(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    //==============@@Weekly@@=============
                    _buildTab(AppStrings.weekly.tr, 0, () {
                      CommonFilterBox.weeklyBox(context, (plan) {
                        setState(() {
                          selectedIndex = 0;
                          controller.selectedPlan = plan;
                        });
                        weekendPrepController.getWeekendPrepData(
                            id: plan.id ?? '');
                      });
                    }, isWeekly: true),
                    //==============Custom=============
                    _buildTab(AppStrings.custom.tr, 1, () {
                      CommonFilterBox.showCustomDialog(context,
                          (customPlanList) {
                        setState(() {
                          selectedIndex = 1;
                          controller.selectedCustomPlanList = customPlanList;
                        });
                        weekendPrepController.getWeekendPrepData(
                            id: customPlanList.id ?? '');
                      }, showCreateOption: false);
                    }, isSelect: true),
                    //==============Featured=============
                    _buildTab(AppStrings.featured.tr, 2, () {
                      CommonFilterBox.featureBox(context, (selectedPlan) {
                        setState(() {
                          selectedIndex = 2;
                          controller.selectedFeaturePlanList = selectedPlan;
                        });
                        weekendPrepController.getWeekendPrepData(
                            id: selectedPlan.id ?? '');
                      });
                    }, isSelect: true),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Center(
                child: CustomText(
                  text: AppStrings.weekendPrep.tr.toUpperCase(),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1B3B4A),
                  bottom: 16.h,
                ),
              ),

              const Divider(color: Colors.grey, thickness: 1),
              SizedBox(height: 10.h),

              // Dynamic UI based on API
              _buildDynamicUI(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicUI() {
    return Obx(() {
      if (weekendPrepController.rxRequestStatus.value == Status.loading) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(50.h),
            child: const CircularProgressIndicator(color: AppColors.green900),
          ),
        );
      } else if (weekendPrepController.rxRequestStatus.value == Status.error ||
          weekendPrepController.rxRequestStatus.value == Status.internetError) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(50.h),
            child: const CustomText(
                text: "Failed to load weekend prep data.", color: Colors.red),
          ),
        );
      }

      final model = weekendPrepController.weekendPrepData.value;
      final data = model.data;
      if (data == null ||
          ((data.sections?.isEmpty ?? true) &&
              (data.speedPrep?.isEmpty ?? true) &&
              (data.prepNotes?.isEmpty ?? true))) {
        String msg = "Please select a plan to view Weekend Prep.";
        if (model.message?.toLowerCase().contains("no recipes found") == true ||
            model.message?.toLowerCase().contains("not found") == true) {
          msg = "No recipes found in this plan!";
        } else if (model.message != null &&
            model.message!.isNotEmpty &&
            model.message != "Weekend prep advice retrieved successfully!") {
          msg = model.message!;
        }

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomText(
              text: msg,
              color: AppColors.black500,
              fontSize: 16.sp,
              maxLines: 5,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 2)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(RoutePath.prepPreview, extra: {
                      'plan': _getCurrentPlanObject(),
                      'weekendPrepData': data,
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
                        const Icon(Icons.print, color: Colors.white, size: 16),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: "Print Prep Plan".toUpperCase(),
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (data.sections != null)
            ...data.sections!.map((section) => _buildSection(section)),
          if (data.speedPrep != null && data.speedPrep!.isNotEmpty) ...[
            _buildSectionHeader("SPEED PREP", Icons.kitchen),
            SizedBox(height: 10.h),
            ...data.speedPrep!.map((speedPrep) => _buildSpeedPrepItem(
                speedPrep.ingredient ?? "", speedPrep.steps ?? [])),
            SizedBox(height: 20.h),
          ],
          if (data.prepNotes != null && data.prepNotes!.isNotEmpty) ...[
            _buildSectionHeader("PREP NOTES", Icons.edit_note),
            SizedBox(height: 10.h),
            ...data.prepNotes!.map((note) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "• ",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp),
                      Expanded(
                          child: CustomText(
                              text: note,
                              fontSize: 14.sp,
                              textAlign: TextAlign.left,
                              maxLines: 5)),
                    ],
                  ),
                )),
            // SizedBox(height: 10.h),
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(16.w),
            //   decoration: BoxDecoration(
            //     color: const Color(0xffEDF4ED),
            //     borderRadius: BorderRadius.circular(4.r),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CustomText(
            //         text: "Add a note to Weekend Prep...",
            //         color: Colors.grey.shade600,
            //         fontSize: 14.sp,
            //       ),
            //       Icon(Icons.edit, color: Colors.teal, size: 20.sp),
            //     ],
            //   ),
            // ),
            SizedBox(height: 40.h),
          ]
        ],
      );
    });
  }

  Widget _buildSection(PrepSection section) {
    IconData icon = Icons.kitchen;
    String titleUpper = (section.title ?? "").toUpperCase();
    if (titleUpper.contains("BAKE")) icon = Icons.bakery_dining;
    if (titleUpper.contains("PREPARE") || titleUpper.contains("GRAIN"))
      icon = Icons.rice_bowl;
    if (titleUpper.contains("COOK") || titleUpper.contains("MAKE"))
      icon = Icons.soup_kitchen;
    if (titleUpper.contains("STEAM")) icon = Icons.set_meal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(titleUpper, icon),
        SizedBox(height: 15.h),
        if (section.items != null)
          ...section.items!.map((item) => Column(
                children: [
                  _buildRecipeBlock(
                    title: (item.name ?? "").toUpperCase(),
                    ingredients: [item.amount ?? ""],
                    instructions: [item.instruction ?? ""],
                    usedIn: item.usedIn,
                    storage: item.storage,
                  ),
                  SizedBox(height: 20.h),
                ],
              )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.bottomNabColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.bottomNabColor.withValues(alpha: 0.15),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title.toUpperCase(),
            color: AppColors.bottomNabColor,
            fontWeight: FontWeight.w700,
            fontSize: 13.sp,
          ),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.bottomNabColor, size: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index, VoidCallback onTap,
      {bool isWeekly = false, bool isSelect = false}) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.bottomNabColor
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.bottomNabColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
          border: Border.all(
            color: isSelected
                ? AppColors.bottomNabColor
                : const Color(0xFFE2E8F0),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isWeekly) ...[
              Assets.icons.calender.svg(
                height: 16.r,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : const Color(0xFF64748B),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 4.w),
            ],
            CustomText(
              text: title.toUpperCase(),
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
            if (isWeekly || isSelect) ...[
              SizedBox(width: 2.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.sp,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeBlock({
    required String title,
    required List<String> ingredients,
    required List<String> instructions,
    String? usedIn,
    String? storage,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ingredients Column
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1B3B4A),
                fontSize: 14.sp,
                bottom: 12.h,
              ),
              ...ingredients.map((e) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomText(
                      text: e,
                      color: Colors.black87,
                      fontSize: 14.sp,
                      textAlign: TextAlign.left,
                      maxLines: 4,
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(width: 15.w),
        // Instructions Column
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...instructions.map((e) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: CustomText(
                      text: e,
                      color: Colors.black87,
                      fontSize: 14.sp,
                      textAlign: TextAlign.left,
                      maxLines: 10,
                    ),
                  )),
              if (usedIn != null && usedIn.isNotEmpty) ...[
                const Divider(color: Colors.grey),
                SizedBox(height: 5.h),
                CustomText(
                  text: "USED IN:",
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: const Color(0xff1B3B4A),
                  bottom: 5.h,
                  textAlign: TextAlign.left,
                ),
                CustomText(
                  text: usedIn,
                  color: Colors.teal,
                  fontSize: 14.sp,
                  textAlign: TextAlign.left,
                  maxLines: 6,
                ),
                SizedBox(height: 5.h),
              ],
              if (storage != null && storage.isNotEmpty) ...[
                CustomText(
                  text: "STORAGE:",
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: const Color(0xff1B3B4A),
                  bottom: 5.h,
                  textAlign: TextAlign.left,
                ),
                CustomText(
                  text: storage,
                  color: Colors.black87,
                  fontSize: 14.sp,
                  textAlign: TextAlign.left,
                  maxLines: 6,
                ),
              ],
            ],
          ),
        )
      ],
    );
  }

  dynamic _getCurrentPlanObject() {
    if (selectedIndex == 0) {
      return controller.selectedPlan;
    } else if (selectedIndex == 1) {
      return controller.selectedCustomPlanList;
    } else if (selectedIndex == 2) {
      return controller.selectedFeaturePlanList;
    }
    return null;
  }

  String? _getCurrentPlanId() {
    if (selectedIndex == 0) {
      return controller.selectedPlan?.id;
    } else if (selectedIndex == 1) {
      return controller.selectedCustomPlanList?.id;
    } else if (selectedIndex == 2) {
      return controller.selectedFeaturePlanList?.id;
    }
    return null;
  }

  Widget _buildSpeedPrepItem(
      String ingredientName, List<SpeedPrepStep> checklists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xffF3F3F3),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: CustomText(
            text: ingredientName.toUpperCase(),
            fontWeight: FontWeight.w700,
            color: const Color(0xff1B3B4A),
            fontSize: 14.sp,
            textAlign: TextAlign.left,
          ),
        ),
        ...checklists.map((e) => GestureDetector(
              onTap: () {
                final planId = _getCurrentPlanId();
                if (planId != null && e.id != null) {
                  weekendPrepController.toggleSpeedPrep(
                    planId: planId,
                    stepId: e.id!,
                    step: e,
                  );
                } else {
                  toastMessage(message: "Plan ID or Step ID is null");
                  log("Plan ID or Step ID is null. PlanID: $planId, StepID: ${e.id}");
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: e.isLoading
                          ? SizedBox(
                              height: 15.w,
                              width: 15.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.bottomNabColor,
                              ),
                            )
                          : (e.isDone ?? false)
                              ? Icon(Icons.check,
                                  color: AppColors.bottomNabColor, size: 18.sp)
                              : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text: e.text ?? "",
                        color: (e.isDone ?? false)
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        fontSize: 14.sp,
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        decoration: (e.isDone ?? false)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    // Icon(Icons.more_horiz, color: Colors.grey.shade400),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
