import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

void permissionPopUp({
  required BuildContext context,
  // String title = "",
  Color color = Colors.red,
  required VoidCallback ontapNo,
  required VoidCallback ontapYes,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(12.r),
          ),
          // height: 135.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ///<=========================Title========================>

              CustomText(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                text: AppStrings.areYouSureYouWantTo.tr,
                color: AppColors.black500,
                bottom: 20.h,
                top: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///<===================No Button=====================>
                  GestureDetector(
                    onTap: ontapNo,
                    child: Container(
                      alignment: Alignment.center,
                      height: 36.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border:
                              Border.all(width: 1.w, color: AppColors.gray)),
                      child: CustomText(
                        text: AppStrings.no.tr,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.h,
                      ),
                    ),
                  ),

                  ///<===================Yes Button=====================>
                  GestureDetector(
                    onTap: ontapYes,
                    child: Container(
                      alignment: Alignment.center,
                      height: 36.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustomText(
                        text: AppStrings.yes.tr,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.h,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              )
            ],
          ),
        ),
      );
    },
  );
}
