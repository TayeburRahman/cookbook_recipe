import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class IngredientSection extends StatelessWidget {
  const IngredientSection({
    super.key,
    required this.list,
  });

  final List<String>? list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (list != null && list!.isNotEmpty)
          ? list!
              .where((item) => item.trim().isNotEmpty)
              .map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 4.h, right: 12.w),
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            textAlign: TextAlign.start,
                            text: item,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.black300,
                            maxLines: 100,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList()
          : [
              Center(
                child: CustomText(
                  text: "No Data available",
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: AppColors.black300,
                ),
              ),
            ],
    );
  }
}
