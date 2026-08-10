import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  const CustomNavBar({required this.currentIndex, super.key});
  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int bottomNavIndex;

  final List<
      ({
        String route,
        Widget selectedIcon,
        Widget unselectedIcon,
        String label
      })> _navItems = [
    (
      route: RoutePath.homeScreen,
      selectedIcon: Assets.images.homeSelected.image(color: AppColors.white),
      unselectedIcon:
          Assets.images.homeUnselected.image(color: AppColors.black),
      label: AppStrings.home.tr,
    ),
    (
      route: RoutePath.mealPlanSection,
      selectedIcon: Assets.images.mealSelected.image(color: AppColors.white),
      unselectedIcon:
          Assets.images.mealUnselected.image(color: AppColors.black),
      label: AppStrings.mealPlan.tr,
    ),
    (
      route: RoutePath.groceryScreen,
      selectedIcon: Assets.images.grocerySelected.image(color: AppColors.white),
      unselectedIcon:
          Assets.images.groceryUnselected.image(color: AppColors.black),
      label: AppStrings.grocery.tr,
    ),
    (
      route: RoutePath.weekendPrep,
      selectedIcon: Assets.icons.calender.svg(color: AppColors.white),
      unselectedIcon: Assets.icons.calender.svg(color: AppColors.black),
      label: AppStrings.weekendPrep.tr,
    ),
    (
      route: RoutePath.profileScreen,
      selectedIcon: Assets.images.profileSelected.image(color: AppColors.white),
      unselectedIcon:
          Assets.images.profileUnselected.image(color: AppColors.black),
      label: AppStrings.settings.tr,
    ),
    (
      route: RoutePath.recipeBox,
      selectedIcon: Assets.images.profileSelected.image(color: AppColors.white),
      unselectedIcon:
          Assets.images.profileUnselected.image(color: AppColors.black),
      label: AppStrings.recipeBox.tr,
    ),
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: AppColors.bottomNabColor),
        height: 88.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 13.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5, // Only show the first 5 items (Home, Meal Plan, Grocery, Weekend Prep, Profile)
            (index) => Expanded(
              child: InkWell(
                onTap: () => _onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    bottomNavIndex == index
                        ? _navItems[index].selectedIcon
                        : _navItems[index].unselectedIcon,
                    SizedBox(height: 4.h),
                    CustomText(
                      text: _navItems[index].label.tr,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: bottomNavIndex == index
                          ? AppColors.white
                          : AppColors.black500,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    if (widget.currentIndex != index) {
      AppRouter.route.goNamed(_navItems[index].route);
    }
  }
}
