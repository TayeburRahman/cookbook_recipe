import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class CommonHomeAppBar extends StatelessWidget {
  const CommonHomeAppBar(
      {super.key,
      required this.scaffoldKey,
      required this.name,
      required this.image,
      required this.onTap,
      required,
      this.onSearch,
      this.isSearch});

  final String name;
  final VoidCallback onTap;
  final String image;
  final VoidCallback? onSearch;
  final bool? isSearch;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.white,
      margin: EdgeInsets.only(
        top: 32.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
      child: Column(
        children: [
          ///====================================Top Section================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CustomNetworkImage(
                        backgroundColor: Colors.white,
                        boxShape: BoxShape.circle,
                        imageUrl: image,
                        height: 46.h,
                        width: 46.w),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppStrings.welcomeBack.tr,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                            fontSize: 14.sp,
                          ),

                          ///=====================user name =======================
                          Row(
                            children: [
                              Flexible(
                                child: CustomText(
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  text: name,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                  fontSize: 18.sp,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),

              ///==========================Notification button ====================
              IconButton(
                  onPressed: onTap, icon: const Icon(Icons.notification_add))
            ],
          ),
          SizedBox(
            height: 20.h,
          ),

          ///====================================Top Section================================

          isSearch == true
              ? CustomTextField(
                  onTap: onSearch,
                  readOnly: true,
                  fieldBorderColor: AppColors.gray,
                  fillColor: AppColors.white,
                  hintText: AppStrings.searchRecipe.tr,
                  suffixIcon: const Icon(Icons.search),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
