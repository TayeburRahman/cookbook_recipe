import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';

void showCustomSnackBar(String? message,
    {bool isError = true, bool getXSnackBar = false}) {
  // message null বা empty হলে safe exit
  final displayMessage = message?.trim();
  if (displayMessage == null || displayMessage.isEmpty) return;

  if (getXSnackBar) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      message: displayMessage,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(10.sp),
      borderRadius: 8.r,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  } else {
    final context = Get.context;
    if (context == null) return; // context null হলে safe exit
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        right: 10.h,
        top: 10.h,
        bottom: 10.h,
        left: 10.h,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      content: Text(
        displayMessage,
        style: TextStyle(fontSize: 12.w),
      ),
    ));
  }
}

void toastMessage({required String message, bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: isError ? AppColors.red : AppColors.green,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG,
  );
}
