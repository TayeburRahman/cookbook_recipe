// Custom widget for each food item
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';

class FoodItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FoodItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: Colors.green,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for each day
class CustomDayCard extends StatelessWidget {
  final String dayTitle;
  final VoidCallback? onTap;
  final List<Map<String, dynamic>> foodItems;

  const CustomDayCard({
    super.key,
    required this.dayTitle,
    required this.foodItems,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dayTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Handle delete action
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Display each food item
            for (var item in foodItems)
              FoodItem(
                icon: item['icon'],
                text: item['text'],
              ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: onTap,
              child: Center(
                child: Text(
                  'ADD TO $dayTitle',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bottomNabColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
