import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class RecipeBoxCard extends StatefulWidget {
  final String category;
  final String title;
  final String imageUrl;
  final String time;
  final String rating;
  final VoidCallback? onAdd;
  final VoidCallback? onMoreVert;
  final VoidCallback? onFavoriteTap;
  final bool? isRating;
  final bool? isAdd;
  final bool? isMoreVert;
  final bool? isFavorite;
  final VoidCallback? onTap;
  final bool showFavoriteIcon;
  final VoidCallback? onMoreTap;

  const RecipeBoxCard({
    this.showFavoriteIcon = true,
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.rating,
    this.isAdd = false,
    this.isMoreVert = false,
    this.onAdd,
    this.onMoreVert,
    this.onFavoriteTap,
    this.isFavorite = false,
    this.isRating,
    required this.onTap,
    this.onMoreTap,
  });

  @override
  _RecipeBoxCardState createState() => _RecipeBoxCardState();
}

class _RecipeBoxCardState extends State<RecipeBoxCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite ?? false;
  }

  @override
  void didUpdateWidget(covariant RecipeBoxCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      setState(() {
        isFavorite = widget.isFavorite ?? false;
      });
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    if (widget.onFavoriteTap != null) {
      widget.onFavoriteTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 100.h,
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
          border: Border.all(color: AppColors.green.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: CustomNetworkImage(
                imageUrl: widget.imageUrl,
                height: double.infinity,
                width: 110.w,
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 2.h),
                  CustomText(
                    text: widget.title
                            .toString()
                            .replaceAll('-', ' ')
                            .replaceAll('_', ' ')
                            .capitalize ??
                        "",
                    // .toString()
                    // .replaceAll(
                    //   '-',
                    //   ' ',
                    // )
                    // .replaceAll('_', ' ')
                    // .split(' ')
                    // .map(
                    //     (word) => word[0].toUpperCase() + word.substring(1))
                    // .join(' '),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  () {
                    final categories = widget.category
                        .split(', ')
                        .where((s) => s.isNotEmpty)
                        .toList();
                    final displayedCategories = categories.take(2).toList();
                    final remainingCount =
                        categories.length - displayedCategories.length;

                    return Wrap(
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: [
                        ...displayedCategories.map((cat) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppColors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                    color: AppColors.green
                                        .withValues(alpha: 0.2)),
                              ),
                              child: CustomText(
                                text: cat
                                        .replaceAll('-', ' ')
                                        .replaceAll('_', ' ')
                                        .capitalizeFirst ??
                                    cat,
                                fontWeight: FontWeight.w600,
                                fontSize: 8.sp,
                                color: AppColors.green,
                              ),
                            )),
                        if (remainingCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.1)),
                            ),
                            child: CustomText(
                              text: "+$remainingCount more",
                              fontWeight: FontWeight.w600,
                              fontSize: 8.sp,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    );
                  }(),
                  // if (protein != null &&
                  //     carbs != null &&
                  //     fat != null &&
                  //     fiver != null)
                  //   CustomText(
                  //     text:
                  //         "🥩 ${protein ?? ""} 🍞 ${carbs ?? ""}\n🧈 ${fat ?? ""} 🌿 ${fiver ?? ""}",
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 7.sp,
                  //     maxLines: 2,
                  //     textAlign: TextAlign.start,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              const Icon(Icons.watch_later, size: 16),
                              SizedBox(width: 8.w),
                              CustomText(
                                text: widget.time,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.blacks,
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              if (widget.isRating == true) ...[
                                const Icon(Icons.star, size: 16),
                                // SizedBox(width: 5.w),
                                CustomText(
                                  text: widget.rating,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  color: AppColors.black,
                                ),
                              ],
                              const Spacer(),
                              // ✅ Favorite Icon Button
                              if (widget.showFavoriteIcon)
                                IconButton(
                                  onPressed: toggleFavorite,
                                  icon: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                ),

                              // // ✅ Swap icon (unchanged)
                              // widget.isSwap == true
                              //     ? GestureDetector(
                              //   onTap: () {
                              //     CommonFilterBox.swapBox(context);
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 11, horizontal: 3),
                              //     decoration: const BoxDecoration(
                              //       color: AppColors.green,
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: Assets.icons.arrowRight.svg(),
                              //   ),
                              // )
                              //     : const SizedBox(),
                            ],
                          ),
                        ),
                        widget.isAdd == true
                            ? GestureDetector(
                                onTap: widget.onAdd,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: CustomText(
                                    text: AppStrings.add.tr,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 7,
                              ),
                        widget.isMoreVert == true
                            ? GestureDetector(
                                onTap: widget.onMoreVert,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );

    // GestureDetector(
    //   onTap: widget.onTap,
    //   child: Container(
    //     padding: EdgeInsets.all(10.w),
    //     decoration: BoxDecoration(
    //       color: AppColors.greenLight,
    //       borderRadius: BorderRadius.circular(15.r),
    //     ),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(10.r),
    //           child: CustomNetworkImage(
    //             imageUrl: widget.imageUrl,
    //             height: 120.h,
    //             width: 121.w,
    //           ),
    //         ),
    //         SizedBox(width: 10.w),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                     child: CustomText(
    //                       textAlign: TextAlign.start,
    //                       maxLines: 10,
    //                       text: widget.category,
    //                       fontWeight: FontWeight.w700,
    //                       fontSize: 13.sp,
    //                       color: AppColors.black500,
    //                     ),
    //                   ),
    //                   const Spacer(),
    //                   widget.isAdd == true
    //                       ? GestureDetector(
    //                           onTap: widget.onAdd,
    //                           child: Container(
    //                             height: 23.h,
    //                             width: 23.w,
    //                             decoration: const BoxDecoration(
    //                               color: AppColors.green,
    //                               shape: BoxShape.circle,
    //                             ),
    //                             child: Assets.images.add.svg(),
    //                           ),
    //                         )
    //                       : const SizedBox(
    //                           width: 7,
    //                         ),
    //                   widget.isMoreVert == true
    //                       ? GestureDetector(
    //                           onTap: widget.onMoreVert,
    //                           child: Container(
    //                             decoration: const BoxDecoration(
    //                               color: AppColors.green,
    //                               shape: BoxShape.circle,
    //                             ),
    //                             padding: const EdgeInsets.all(8),
    //                             child: const Icon(
    //                               Icons.more_horiz,
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                         )
    //                       : const SizedBox()
    //                 ],
    //               ),
    //               SizedBox(height: 10.h),
    //               CustomText(
    //                 maxLines: 2,
    //                 text: widget.title,
    //                 fontWeight: FontWeight.w300,
    //                 fontSize: 11.sp,
    //                 color: AppColors.blacks,
    //               ),
    //               SizedBox(height: 45.h),
    //               Row(
    //                 children: [
    //                   const Icon(Icons.watch_later, size: 16),
    //                   SizedBox(width: 8.w),
    //                   CustomText(
    //                     text: widget.time,
    //                     fontWeight: FontWeight.w400,
    //                     fontSize: 10.sp,
    //                     color: AppColors.blacks,
    //                   ),
    //                   SizedBox(
    //                     width: 7.w,
    //                   ),
    //                   if (widget.isRating == true) ...[
    //                     const Icon(Icons.star, size: 16),
    //                     // SizedBox(width: 5.w),
    //                     CustomText(
    //                       text: widget.rating,
    //                       fontWeight: FontWeight.w400,
    //                       fontSize: 10.sp,
    //                       color: AppColors.black,
    //                     ),
    //                   ],
    //                   const Spacer(),
    //                   // ✅ Favorite Icon Button
    //                   if (widget.showFavoriteIcon)
    //                     IconButton(
    //                       onPressed: toggleFavorite,
    //                       icon: Container(
    //                         padding: EdgeInsets.all(4.r),
    //                         decoration: const BoxDecoration(
    //                           shape: BoxShape.circle,
    //                           color: AppColors.green,
    //                         ),
    //                         child: Icon(
    //                           isFavorite
    //                               ? Icons.favorite
    //                               : Icons.favorite_border,
    //                           color: isFavorite ? Colors.red : Colors.white,
    //                         ),
    //                       ),
    //                     ),

    //                   // // ✅ Swap icon (unchanged)
    //                   // widget.isSwap == true
    //                   //     ? GestureDetector(
    //                   //   onTap: () {
    //                   //     CommonFilterBox.swapBox(context);
    //                   //   },
    //                   //   child: Container(
    //                   //     padding: const EdgeInsets.symmetric(
    //                   //         vertical: 11, horizontal: 3),
    //                   //     decoration: const BoxDecoration(
    //                   //       color: AppColors.green,
    //                   //       shape: BoxShape.circle,
    //                   //     ),
    //                   //     child: Assets.icons.arrowRight.svg(),
    //                   //   ),
    //                   // )
    //                   //     : const SizedBox(),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
