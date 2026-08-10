import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';

import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomDialogAlert {
//Delete Dialog
  static showDeleteDialog(BuildContext context, Widget button, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.red, size: 28.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: AppStrings.confirmDelete.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green900,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CustomText(
              text: title,
              fontSize: 14.sp,
              color: AppColors.black500,
              textAlign: TextAlign.start,
              maxLines: 4,
            ),
          ),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomText(
                text: AppStrings.cancel.tr,
                color: AppColors.black200,
                fontWeight: FontWeight.w600,
              ),
            ),
            button
          ],
        );
      },
    );
  }

  //====================Are You Sure Want To Delete==============
  static showDeleteConfirmationDialog(
      BuildContext context, VoidCallback onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.help_outline_rounded,
                  color: AppColors.green, size: 28.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: "Are you sure?".tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green900,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CustomText(
              text: "Do you really want to delete this item?".tr,
              fontSize: 14.sp,
              color: AppColors.black500,
              textAlign: TextAlign.start,
              maxLines: 3,
            ),
          ),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          actions: <Widget>[
            // "No" button
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: CustomText(
                text: "No".tr,
                color: AppColors.black200,
                fontWeight: FontWeight.w600,
              ),
            ),
            // "Yes" button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onTap();
              },
              child: CustomText(
                text: "Yes".tr,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}
