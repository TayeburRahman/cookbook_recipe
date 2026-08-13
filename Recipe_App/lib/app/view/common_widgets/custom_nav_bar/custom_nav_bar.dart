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
        Widget Function(Color color) iconBuilder,
        String label
      })> _navItems = [
    (
      route: RoutePath.homeScreen,
      iconBuilder: (color) =>
          Assets.images.homeSelected.image(color: color, height: 22.r, width: 22.r),
      label: AppStrings.home.tr,
    ),
    (
      route: RoutePath.mealPlanSection,
      iconBuilder: (color) =>
          Assets.images.mealSelected.image(color: color, height: 22.r, width: 22.r),
      label: AppStrings.mealPlan.tr,
    ),
    (
      route: RoutePath.groceryScreen,
      iconBuilder: (color) =>
          Assets.images.grocerySelected.image(color: color, height: 22.r, width: 22.r),
      label: AppStrings.grocery.tr,
    ),
    (
      route: RoutePath.weekendPrep,
      iconBuilder: (color) =>
          Assets.icons.calender.svg(color: color, height: 22.r, width: 22.r),
      label: AppStrings.weekendPrep.tr,
    ),
    (
      route: RoutePath.profileScreen,
      iconBuilder: (color) =>
          Assets.images.profileSelected.image(color: color, height: 22.r, width: 22.r),
      label: AppStrings.settings.tr,
    ),
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeGreen = AppColors.bottomNabColor; // Color(0xff016445)
    final inactiveGrey = const Color(0xFF94A3B8);

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 12.h, top: 4.h),
          child: Container(
            height: 68.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: activeGreen.withValues(alpha: 0.08),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFF1F5F9),
                width: 1.5.w,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                5,
                (index) {
                  final isSelected = bottomNavIndex == index;

                  return Expanded(
                    child: InkWell(
                      onTap: () => _onTap(index),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activeGreen.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22.r),
                          border: isSelected
                              ? Border.all(
                                  color: activeGreen.withValues(alpha: 0.25),
                                  width: 1.w,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _navItems[index].iconBuilder(
                              isSelected ? activeGreen : inactiveGrey,
                            ),
                            SizedBox(height: 3.h),
                            CustomText(
                              text: _navItems[index].label,
                              fontSize: 10.sp,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? activeGreen : const Color(0xFF64748B),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
