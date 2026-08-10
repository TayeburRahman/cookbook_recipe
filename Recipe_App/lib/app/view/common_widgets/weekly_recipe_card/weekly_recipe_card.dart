import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../custom_network_image/custom_network_image.dart';
import '../custom_text/custom_text.dart';
import '../rating_star/rating_star.dart';

class WeeklyRecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  // final String? dayNutrition;
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
    // this.dayNutrition,
    this.protein,
    this.carbs,
    this.fat,
    this.fiver,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      child: Container(
        // height: 110.h,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xffEEEEEE)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                child: CustomNetworkImage(
                  imageUrl: Uri.encodeFull(imageUrl),
                  height: double.infinity,
                  width: 100.w,
                ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    // () {
                    //   final categories = category
                    //       .split(', ')
                    //       .where((s) => s.isNotEmpty)
                    //       .toList();
                    //   final displayedCategories = categories.take(2).toList();
                    //   final remainingCount =
                    //       categories.length - displayedCategories.length;

                    //   return Wrap(
                    //     spacing: 4.w,
                    //     runSpacing: 4.h,
                    //     children: [
                    //       ...displayedCategories.map((cat) => Container(
                    //             padding: EdgeInsets.symmetric(
                    //                 horizontal: 8.w, vertical: 2.h),
                    //             decoration: BoxDecoration(
                    //               color: AppColors.green.withValues(alpha: 0.1),
                    //               borderRadius: BorderRadius.circular(10.r),
                    //               border: Border.all(
                    //                   color: AppColors.green
                    //                       .withValues(alpha: 0.2)),
                    //             ),
                    //             child: CustomText(
                    //               text: cat
                    //                       .replaceAll('-', ' ')
                    //                       .replaceAll('_', ' ')
                    //                       .capitalizeFirst ??
                    //                   cat,
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: 8.sp,
                    //               color: AppColors.green,
                    //             ),
                    //           )),
                    //       if (remainingCount > 0)
                    //         Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 8.w, vertical: 2.h),
                    //           decoration: BoxDecoration(
                    //             color: Colors.black.withValues(alpha: 0.05),
                    //             borderRadius: BorderRadius.circular(10.r),
                    //             border: Border.all(
                    //                 color: Colors.black.withValues(alpha: 0.1)),
                    //           ),
                    //           child: CustomText(
                    //             text: "+$remainingCount more",
                    //             fontWeight: FontWeight.w700,
                    //             fontSize: 8.sp,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //     ],
                    //   );
                    // }(),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: title.toString(),
                      color: const Color(0xff1B3B4A),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    if (protein != null &&
                        carbs != null &&
                        fat != null &&
                        fiver != null)
                      CustomText(
                        text:
                            "🥩 ${protein ?? ""} 🍞 ${carbs ?? ""}\n🧈 ${fat ?? ""} 🌿 ${fiver ?? ""}",
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 9.sp,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStar(
                          rating: rating,
                          textColor: Colors.black,
                        ),
                        GestureDetector(
                          onTap: onMoreTap,
                          child: Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xffBDC7CD)),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.more_horiz,
                                color: Color(0xffBDC7CD), size: 18),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildNutritionText(String emoji, String value) {
  //   return Row(
  //     children: [
  //       Text(
  //         emoji,
  //         style: TextStyle(fontSize: 14.sp),
  //       ),
  //       SizedBox(width: 4.w),
  //       CustomText(
  //         text: value,
  //         fontSize: 12.sp,
  //         color: Colors.white,
  //       ),
  //     ],
  //   );
  // }
}
