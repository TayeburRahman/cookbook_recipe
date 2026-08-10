import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomMenuCard extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onTap;
  final bool isTextRed;
  final bool isArrow;
  final bool isContainerCard;

  const CustomMenuCard(
      {super.key,
      required this.text,
      required this.icon,
      this.onTap,
      this.isTextRed = false,
      this.isArrow = false,
      this.isContainerCard = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isContainerCard
            ? GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.green),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        icon,
                        SizedBox(width: 16.w),
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(
                                child: CustomText(
                                    text: text,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (isArrow)
                          const SizedBox()
                        else
                          Assets.images.chevronRight.image(),
                      ],
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      icon,
                      SizedBox(width: 16.w),
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: CustomText(
                                text: text,
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                color:
                                    isTextRed ? AppColors.red : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const Spacer(),
                      if (isArrow)
                        const SizedBox()
                      else
                        Assets.images.chevronRight.image(color: Colors.black),
                    ],
                  ),
                ),
              ),
        SizedBox(
          height: 16.h,
        )
      ],
    );
  }
}
