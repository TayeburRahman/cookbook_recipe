import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import '../custom_network_image/custom_network_image.dart';
import '../custom_text/custom_text.dart';
import '../rating_star/rating_star.dart';

class WeeklyRecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String? protein;
  final String? carbs;
  final String? fat;
  final String? fiver;
  final double? rating;
  final VoidCallback onCardTap;
  final VoidCallback onMoreTap;

  const WeeklyRecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    this.rating,
    required this.onCardTap,
    required this.onMoreTap,
    this.protein,
    this.carbs,
    this.fat,
    this.fiver,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CustomNetworkImage(
                  imageUrl: Uri.encodeFull(imageUrl),
                  height: double.infinity,
                  width: 95.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (category.isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.bottomNabColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: CustomText(
                              text: category,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bottomNabColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4.h),
                        ],
                        CustomText(
                          text: title.toString(),
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (protein != null && carbs != null && fat != null && fiver != null) ...[
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 4.w,
                        runSpacing: 4.h,
                        children: [
                          _buildMacroBadge("🥩", protein!),
                          _buildMacroBadge("🍞", carbs!),
                          _buildMacroBadge("🧈", fat!),
                          _buildMacroBadge("🌿", fiver!),
                        ],
                      ),
                    ],
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStar(
                          rating: rating,
                          textColor: const Color(0xFF475569),
                        ),
                        GestureDetector(
                          onTap: onMoreTap,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF8FAFC),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Color(0xFF64748B),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroBadge(String emoji, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        "$emoji $value",
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }
}
