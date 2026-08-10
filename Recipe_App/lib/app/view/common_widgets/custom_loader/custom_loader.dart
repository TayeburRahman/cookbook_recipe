import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: AppColors.green900,
        size: 60.0.sp,
      ),
    );
  }
}
