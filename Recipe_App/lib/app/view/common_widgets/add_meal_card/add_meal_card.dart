import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import '../../../utils/app_colors/app_colors.dart';

class AddMealCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const AddMealCard({
    super.key,
    this.onTap,
    this.text = AppStrings.addAMealForThisDay,
    this.icon = Icons.add,
    this.borderColor = AppColors.green,
    this.iconColor = AppColors.green,
    this.textColor = AppColors.green,
    this.iconSize = 20,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.margin = const EdgeInsets.only(bottom: 10),
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.green.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
            const SizedBox(width: 8),
            Text(
              text.tr,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
