import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomHomeCard extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final double elevation;

  const CustomHomeCard({
    super.key,
    required this.title,
    required this.image,
    this.color = AppColors.white, // default color from AppColors
    this.elevation = 5.0, // elevation default
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      margin: EdgeInsets
          .zero, // FIX: Removes the default 4px margin around the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        // Reduced padding from 16.r to 8.r to stop content from feeling "squeezed"
        padding: EdgeInsets.all(8.r),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center items vertically
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomNetworkImage(
                backgroundColor: Colors.white,
                boxShape: BoxShape.circle,
                imageUrl: image,
                height: 45.h, // Slightly smaller to ensure it fits the grid row
                width: 45.w,
              ),
              SizedBox(height: 8.h), // Reduced from 12.h
              CustomText(
                text: title,
                fontSize: 12.sp, // Slightly smaller for better fit
                fontWeight: FontWeight.w400,
                color: AppColors.black500,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
