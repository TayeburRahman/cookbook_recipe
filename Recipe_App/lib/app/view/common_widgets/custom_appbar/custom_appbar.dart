import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final double? appBarWidth;
  final Color appBarBgColor;
  final String? appBarContent;
  final IconData? iconData;
  final bool isIcon;
  final bool? skipButton;
  final bool? isFilter;
  final bool? isArrow;
  final bool? addButton;
  final VoidCallback? onTap;
  final VoidCallback? skipButtonTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onArrowTap;
  final VoidCallback? addTap;

  const CustomAppBar({
    this.appBarHeight = 64,
    this.appBarWidth,
    this.appBarBgColor = AppColors.white,
    this.appBarContent,
    super.key,
    this.iconData,
    this.isIcon = false,
    this.onTap,
    this.isFilter = false,
    this.skipButton = false,
    this.skipButtonTap,
    this.onFilterTap,
    this.isArrow = false,
    this.onArrowTap,
    this.addButton = false,
    this.addTap,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(appBarWidth ?? double.infinity, appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors.white,
      backgroundColor: widget.appBarBgColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            if (widget.iconData != null)
              IconButton(
                icon: Icon(widget.iconData),
                color: AppColors.black,
                onPressed: () {
                  AppRouter.route.pop();
                },
              ),
            if (widget.appBarContent != null)
              Expanded(
                child: CustomText(
                  text: widget.appBarContent!,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColors.black,
                ),
              ),
            if (widget.skipButton == true)
              IconButton(
                onPressed: widget.skipButtonTap,
                icon: const CustomText(
                  text: "Skip",
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                tooltip: '',
              ),
            if (widget.isIcon)
              IconButton(
                onPressed: widget.onTap,
                icon: Assets.icons.edit.svg(
                  colorFilter:
                      const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
                tooltip: '',
              ),
            if (widget.isFilter == true)
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Container(
                  // height: 50.h,
                  padding: EdgeInsets.all(8.0.r),
                  decoration: const BoxDecoration(
                    color: AppColors.green900,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Assets.images.filter.image(),
                ),
              ),
            // GestureDetector(
            //     onTap: widget.onFilterTap,
            //     child: Assets.images.filter.image(color: AppColors.green)),
            if (widget.isArrow == true)
              GestureDetector(
                  onTap: widget.onArrowTap,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(),
                      child:
                          Assets.icons.arrowRight.svg(color: AppColors.green))),
            if (widget.addButton == true)
              GestureDetector(
                  onTap: widget.addTap,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.bottomNabColor,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: AppStrings.addToPlan.tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
