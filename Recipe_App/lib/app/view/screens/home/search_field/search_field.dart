import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/view/screens/profile_screen/recipe_box/controller/recipe_box_controller.dart';

class SearchFilterRow extends StatelessWidget {
  final VoidCallback onFilterTap;

  SearchFilterRow({super.key, required this.onFilterTap});

  final RecipeBoxController controller = Get.find<RecipeBoxController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          inputTextStyle: const TextStyle(color: AppColors.black),
          textEditingController: controller.searchController,
          onChanged: (value) {
            controller.search(search: value.trim());
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          // maxLength: 50,
          hintText: AppStrings.searchHere.tr,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.green,
          ),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(color: const Color(0xffBDC7CD)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 14.h,
                  width: 14.w,
                  child: Assets.images.filter.image(
                    color: const Color(0xff1B3B4A),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.showFilters.tr.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xff1B3B4A),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
