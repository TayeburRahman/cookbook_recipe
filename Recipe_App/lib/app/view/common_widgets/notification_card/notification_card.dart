import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart'; // for .w, .h, .r, .sp

class NotificationCard extends StatelessWidget {
  final String message;
  final String time;
  final String title;

  const NotificationCard({
    super.key,
    required this.message,
    required this.time,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.green900),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notification_important),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.green,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            CustomText(
              left: 30.w,
              textAlign: TextAlign.start,
              color: AppColors.grey1,
              text: message,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              maxLines: 5,
            )
          ],
        ),
      ),
    );
  }
}
