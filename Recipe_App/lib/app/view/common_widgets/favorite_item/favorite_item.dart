import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class FavoriteItem extends StatefulWidget {
  final String category;
  final String title;
  final String imageUrl;
  final String time;
  final String rating;
  final VoidCallback onEdit;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;
  final VoidCallback? onMoreVert;
  final bool isEdit;
  final bool? isFavorites;
  final bool? isRating;
  final bool? isSwap;
  final bool? isBgWhiteColor;
  final bool? isAdd;
  final bool? isMoreVert;
  final RxBool? isFavorite; // Pass the RxBool state here

  const FavoriteItem({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.rating,
    required this.onEdit,
    this.onRemove,
    this.isEdit = false,
    this.isAdd = false,
    this.isMoreVert = false,
    this.onAdd,
    this.onMoreVert,
    this.isFavorites = false,
    this.isSwap,
    this.isFavorite,
    this.isRating,
    this.isBgWhiteColor,
  });

  @override
  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  bool isFavorite = false; // Track the favorite icon state

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle the state of the favorite icon
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: widget.isBgWhiteColor == true
            ? AppColors.greenLight
            : AppColors.cardColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CustomNetworkImage(
                imageUrl: widget.imageUrl, height: 120.h, width: 100.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    // const Spacer(),
                    widget.isAdd == true
                        ? GestureDetector(
                            onTap: widget.onAdd,
                            child: Container(
                                height: 23.h,
                                width: 23.w,
                                decoration: const BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle),
                                child: Assets.images.add.svg()),
                          )
                        : const SizedBox(),
                    widget.isMoreVert == true
                        ? GestureDetector(
                            onTap: widget.onMoreVert,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                height: 23.h,
                                width: 23.w,
                                decoration: const BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle),
                                child: Assets.icons.more.svg()),
                          )
                        : const SizedBox(),
                    if (widget.isEdit) ...[
                      GestureDetector(
                        onTap: widget.onEdit,
                        child: Assets.images.edits
                            .image(height: 20.h, width: 20.w),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: widget.onRemove,
                        child: Assets.images.remove.image(
                            height: 20.h,
                            width: 20.w,
                            color: AppColors.normalRed),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: widget.title,
                  fontWeight: FontWeight.w300,
                  fontSize: 11.sp,
                  color: AppColors.blacks,
                ),
                SizedBox(height: 50.h),
                Row(
                  children: [
                    const Icon(Icons.watch_later, size: 16),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: widget.time,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      color: AppColors.blacks,
                    ),
                    SizedBox(width: 10.w),
                    if (widget.isRating == true) ...[
                      const Icon(Icons.star, size: 16),
                      SizedBox(width: 5.w),
                      CustomText(
                        text: widget.rating, // Display the rating
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.black,
                      ),
                    ],
                    const Spacer(),
                    widget.isFavorites == true
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: widget
                                .onAdd, // Use onAdd to call the function to add/remove favorite
                            child: Icon(
                              widget.isFavorite?.value ?? false
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.green900,
                              size: 24.h,
                            ),
                          ),
                    widget.isSwap == true
                        ? GestureDetector(
                            onTap: () {
                              CommonFilterBox.swapBox(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 3),
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Assets.icons.arrowRight.svg(),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
