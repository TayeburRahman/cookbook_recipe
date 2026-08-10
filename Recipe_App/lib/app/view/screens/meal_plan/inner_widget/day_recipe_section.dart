import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class DayRecipeSection extends StatelessWidget {
  final int index;
  final VoidCallback addRecipe;
  const DayRecipeSection({super.key, required this.index, required this.addRecipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "DAY ${index + 1}",
          bottom: 10.h,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black500,
        ),
        DottedBorder(
          padding: EdgeInsets.all(15.r),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.add,
                  color: AppColors.green900,
                ),
                CustomText(
                  top: 4.h,
                  text: "Drag and drop a recipe here, or add a recipe",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white900,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 11.h),
        Center(
          child: GestureDetector(
            onTap: addRecipe,
            child: Column(
              children: [
                const Icon(
                  Icons.add,
                  color: AppColors.green900,
                  size: 30,
                ),
                CustomText(
                  text: "Add Recipe",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
